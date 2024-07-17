# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_17_155217) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "meeting_link"
    t.string "status"
    t.bigint "interviewee_id"
    t.bigint "interviewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interviewee_id"], name: "index_bookings_on_interviewee_id"
    t.index ["interviewer_id"], name: "index_bookings_on_interviewer_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chatrooms_on_user_id"
  end

  create_table "flashcard_decks", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.float "completion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flashcards", force: :cascade do |t|
    t.bigint "flashcard_deck_id", null: false
    t.string "question"
    t.string "answer"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_deck_id"], name: "index_flashcards_on_flashcard_deck_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "chatroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.integer "rating"
    t.bigint "booking_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "icon_url"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_decks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "flashcard_deck_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_deck_id"], name: "index_user_decks_on_flashcard_deck_id"
    t.index ["user_id"], name: "index_user_decks_on_user_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "years_experience"
    t.string "address"
    t.string "username"
    t.boolean "interviewer"
    t.string "headline"
    t.text "about"
    t.string "linkedin"
    t.string "github"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "users", column: "interviewee_id"
  add_foreign_key "bookings", "users", column: "interviewer_id"
  add_foreign_key "chatrooms", "users"
  add_foreign_key "flashcards", "flashcard_decks"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "user_decks", "flashcard_decks"
  add_foreign_key "user_decks", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
end
