require "test_helper"

class BookingTest < ActiveSupport::TestCase
  # A small builder keeps each test focused on the one attribute it changes.
  def build_booking(**attrs)
    Booking.new({
      interviewer: users(:alice),
      interviewee: users(:bob),
      start_time: 1.day.from_now,
      end_time: 1.day.from_now + 1.hour
    }.merge(attrs))
  end

  test "is valid with an interviewer, interviewee and future times" do
    assert build_booking.valid?
  end

  test "requires a start and end time" do
    booking = build_booking(start_time: nil, end_time: nil)

    assert_not booking.valid?
    assert_includes booking.errors[:start_time], "can't be blank"
    assert_includes booking.errors[:end_time], "can't be blank"
  end

  test "blank time strings from the form become nil instead of crashing" do
    booking = build_booking(start_time: "", end_time: "")

    assert_not booking.valid?
    assert_nil booking.start_time
  end

  test "start time must be in the future" do
    booking = build_booking(start_time: 1.hour.ago, end_time: 1.hour.from_now)

    assert_not booking.valid?
    assert_includes booking.errors[:start_time], "must be in the future"
  end

  test "end time must be after start time" do
    booking = build_booking(end_time: 1.day.from_now - 1.hour)

    assert_not booking.valid?
    assert_includes booking.errors[:end_time], "must be after start time"
  end

  test "a booking whose start has passed can still change status" do
    booking = bookings(:past)

    assert booking.update(status: "rejected")
  end

  test "new bookings start as pending" do
    assert build_booking.pending?
  end

  test "rejects unknown statuses instead of raising" do
    booking = build_booking(status: "hacked")

    assert_not booking.valid?
    assert booking.errors[:status].any?
  end

  test "creating a booking opens a chatroom with both participants" do
    booking = build_booking

    assert_difference "Chatroom.count", 1 do
      booking.save!
    end
    assert_equal [users(:alice), users(:bob)].sort, booking.chatroom.users.sort
  end

  test "meeting link must be an http(s) URL" do
    assert_not build_booking(meeting_link: "javascript:alert(1)").valid?
    assert build_booking(meeting_link: "https://meet.example.com/abc").valid?
  end
end
