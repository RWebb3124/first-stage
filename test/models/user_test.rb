require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "fixtures are valid" do
    assert users(:alice).valid?, users(:alice).errors.full_messages.to_sentence
    assert users(:bob).valid?, users(:bob).errors.full_messages.to_sentence
  end

  test "interviewers need a headline, experience and an about section" do
    user = users(:bob)
    user.interviewer = true

    assert_not user.valid?
    assert user.errors[:headline].any?
    assert user.errors[:years_experience].any?
    assert user.errors[:about].any?
  end

  test "username must be unique" do
    user = users(:carol)
    user.username = users(:alice).username

    assert_not user.valid?
    assert_includes user.errors[:username], "has already been taken"
  end

  test "profile links reject javascript: URLs" do
    user = users(:bob)
    user.linkedin = "javascript:alert(1)"

    assert_not user.valid?
    assert user.errors[:linkedin].any?
  end

  test "profile links without a scheme get https:// added" do
    user = users(:bob)
    user.github = "  github.com/bob "

    assert_equal "https://github.com/bob", user.github
    assert user.valid?
  end

  test "an empty profile link from the form is saved as nil" do
    user = users(:bob)
    user.github = ""

    assert_nil user.github
    assert user.valid?
  end

  test "chatrooms returns only rooms from the user's own bookings" do
    assert_equal [chatrooms(:past), chatrooms(:upcoming)].sort, users(:bob).chatrooms.sort
    assert_empty users(:carol).chatrooms
  end
end
