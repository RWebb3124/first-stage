# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

"First Stage" is a Rails 7.1 app (Ruby 3.1.2, PostgreSQL) for booking mock interviews: users browse interviewer profiles, book a time slot, chat with the interviewer in real time, and leave reviews. Generated from the Le Wagon rails-templates (Devise + Bootstrap + Simple Form).

## Commands

```bash
bin/setup                      # install gems, prepare DB
bin/rails db:create db:migrate db:seed
bin/rails server               # dev server on :3000 (Redis must be running for Action Cable)
bin/rails test                 # run all tests
bin/rails test test/models/booking_test.rb      # single file
bin/rails test test/models/booking_test.rb:5    # single test by line
bin/rails test:system          # Capybara/Selenium system tests
bundle exec rubocop            # lint (config in .rubocop.yml; test/, db/, config/ excluded)
bin/importmap pin <pkg>        # add a JS dependency
```

Note: the test files are currently all generated stubs with no real assertions.

Deploys to Heroku (`heroku` git remote); a Dockerfile also exists. `config.force_ssl = true` in production.

## Architecture

**Front end** uses importmap (no Node build step; `package.json` is vestigial), Turbo, and Stimulus. Stimulus controllers in `app/javascript/controllers/` are auto-registered. Styling is Bootstrap 5 via `sassc-rails`. JS libraries such as flatpickr and star-rating.js are pinned in `config/importmap.rb`.

**Core domain: Users play two roles.** There is a single `User` model (Devise). A boolean `interviewer` flag switches on extra profile validations (`years_experience`, `headline`, `about`). Users opt in through `InterviewersController#become_interviewer` / `#upgrade_to_interviewer`, which are nested as member routes under `users`. `Booking` links two users through `interviewer_id` and `interviewee_id`, and `User` exposes these as `bookings_as_interviewer` and `bookings_as_interviewee`.

**Booking → Chatroom → Messages pipeline:**
- `Booking` has an `after_create` callback that creates a `Chatroom` plus two `ChatroomUser` rows (one for the interviewer, one for the interviewee). Every booking therefore has exactly one chatroom.
- `Message` has an `after_create_commit` callback that runs `broadcast_append_to chatroom, target: "messages"` (Turbo Streams). `ChatroomChannel` and `chatroom_subscription_controller.js` handle the Action Cable side. Redis is the cable adapter in development and production.
- `User#chatrooms` is a hand-written method that overrides the `has_many :chatrooms` associations declared above it. Use the method.
- `Booking#status` is a string enum (`pending`, `accepted`, `rejected`), non-null, defaulting to `pending`.
- `ApplicationController` loads `@chatrooms` on every request for the messages sidebar. It also requires authentication globally (`before_action :authenticate_user!`).

**Reviews** belong to a `Booking`, not directly to a user. They are created through the nested route `bookings/:booking_id/reviews`.

**Video calls**: the old Zoom OAuth integration has been removed and no video provider is wired up yet. `bookings.meeting_link` is kept for a future provider; views only show a meeting link when one is present (and passes `safe_url`).

**Custom booking routes** sit alongside the REST resources: `/users/:interviewer_id/bookings/new`, `/mybookings`, `/myinterviews`, and `PATCH /mybookings/:booking_id/update_status`.

**Flashcards** (`FlashcardDeck`, `Flashcard`, `UserDeck`) and **Tags** (`Tag`, `UserTag`, used for interviewer filtering) are models with no dedicated controllers yet.

**File uploads**: Active Storage (`User#photo`, `User#banner_photo`) backed by Cloudinary in both development and production.

## Environment

`.env` (loaded by `dotenv-rails` in dev and test) needs `CLOUDINARY_URL`. Production also needs `REDIS_URL`.
