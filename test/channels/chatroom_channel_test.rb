require "test_helper"

class ChatroomChannelTest < ActionCable::Channel::TestCase
  test "members subscribe to their chatroom's stream" do
    stub_connection current_user: users(:bob)

    subscribe id: chatrooms(:upcoming).id

    assert subscription.confirmed?
    assert_has_stream_for chatrooms(:upcoming)
  end

  test "strangers are rejected" do
    stub_connection current_user: users(:carol)

    subscribe id: chatrooms(:upcoming).id

    assert subscription.rejected?
  end

  test "unknown chatroom ids are rejected" do
    stub_connection current_user: users(:bob)

    subscribe id: 0

    assert subscription.rejected?
  end
end
