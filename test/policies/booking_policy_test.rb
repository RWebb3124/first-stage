require "test_helper"

class BookingPolicyTest < ActiveSupport::TestCase
  def policy(user, booking = bookings(:upcoming))
    BookingPolicy.new(user, booking)
  end

  test "a user can request a booking with an interviewer" do
    booking = Booking.new(interviewer: users(:alice))

    assert policy(users(:bob), booking).create?
  end

  test "nobody can book themselves" do
    booking = Booking.new(interviewer: users(:alice))

    assert_not policy(users(:alice), booking).create?
  end

  test "nobody can book a user who is not an interviewer" do
    booking = Booking.new(interviewer: users(:carol))

    assert_not policy(users(:bob), booking).create?
  end

  test "only the interviewer can reschedule" do
    assert policy(users(:alice)).update?
    assert_not policy(users(:bob)).update?
    assert_not policy(users(:carol)).update?
  end

  test "either participant can cancel, strangers cannot" do
    assert policy(users(:alice)).destroy?
    assert policy(users(:bob)).destroy?
    assert_not policy(users(:carol)).destroy?
  end

  test "only the interviewer can accept or reject" do
    assert policy(users(:alice)).update_status?
    assert_not policy(users(:bob)).update_status?
    assert_not policy(users(:carol)).update_status?
  end

  test "scope only returns the user's own bookings" do
    assert_equal 2, BookingPolicy::Scope.new(users(:bob), Booking).resolve.count
    assert_empty BookingPolicy::Scope.new(users(:carol), Booking).resolve
  end
end
