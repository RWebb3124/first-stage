require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  def valid_times
    { start_time: 3.days.from_now.to_fs(:db), end_time: (3.days.from_now + 1.hour).to_fs(:db) }
  end

  test "logged-out visitors are sent to sign in" do
    get new_interview_booking_path(users(:alice))

    assert_redirected_to new_user_session_path
  end

  test "a user can request an interview" do
    sign_in users(:bob)

    assert_difference "Booking.count", 1 do
      post interview_booking_path(users(:alice)), params: { booking: valid_times }
    end
    assert_redirected_to myinterviews_path
    assert Booking.unscoped.order(:created_at).last.pending?
  end

  test "blank dates re-render the form instead of crashing" do
    sign_in users(:bob)

    assert_no_difference "Booking.count" do
      post interview_booking_path(users(:alice)), params: { booking: { start_time: "", end_time: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "the form cannot choose who the interviewee is" do
    sign_in users(:bob)

    post interview_booking_path(users(:alice)), params: { booking: valid_times.merge(interviewee_id: users(:carol).id) }

    assert_equal users(:bob), Booking.unscoped.order(:created_at).last.interviewee
  end

  test "the interviewer can accept a request" do
    sign_in users(:alice)

    patch update_booking_status_path(bookings(:upcoming)), params: { status: "accepted" }

    assert_redirected_to my_bookings_path
    assert bookings(:upcoming).reload.accepted?
  end

  test "status can only be accepted or rejected" do
    sign_in users(:alice)

    %w[pending hacked].each do |status|
      patch update_booking_status_path(bookings(:upcoming)), params: { status: status }
      assert bookings(:upcoming).reload.pending?, "status #{status} should have been refused"
    end
  end

  test "the interviewee cannot accept their own request" do
    sign_in users(:bob)

    patch update_booking_status_path(bookings(:upcoming)), params: { status: "accepted" }

    assert bookings(:upcoming).reload.pending?
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "a stranger cannot cancel someone else's booking" do
    sign_in users(:carol)

    assert_no_difference "Booking.count" do
      delete booking_path(bookings(:upcoming))
    end
  end

  test "a stranger cannot reschedule someone else's booking" do
    sign_in users(:carol)
    original_start = bookings(:upcoming).start_time

    patch booking_path(bookings(:upcoming)), params: { booking: valid_times }

    assert_equal original_start, bookings(:upcoming).reload.start_time
  end

  test "my bookings and my interviews pages load" do
    sign_in users(:alice)
    get my_bookings_path
    assert_response :success

    sign_in users(:bob)
    get myinterviews_path
    assert_response :success
  end

  # Uses the customised app/views/simple_calendar/_month_calendar.html.erb,
  # so this catches a simple_calendar upgrade breaking the override.
  test "accepted bookings appear on the my bookings calendar" do
    booking = bookings(:past)
    sign_in users(:alice)

    get my_bookings_path, params: { start_date: booking.start_time.to_date }

    assert_select ".simple-calendar td", 35..42
    assert_select ".simple-calendar .meeting", text: /#{users(:bob).first_name}/
  end
end
