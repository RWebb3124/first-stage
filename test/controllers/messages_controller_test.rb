require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "a member can post a message" do
    sign_in users(:alice)

    assert_difference "Message.count", 1 do
      post chatroom_messages_path(chatrooms(:upcoming)), params: { message: { content: "See you then" } }
    end
    assert_response :success
  end

  test "an empty message is refused" do
    sign_in users(:alice)

    assert_no_difference "Message.count" do
      post chatroom_messages_path(chatrooms(:upcoming)), params: { message: { content: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "a stranger cannot post into someone else's chat" do
    sign_in users(:carol)

    assert_no_difference "Message.count" do
      post chatroom_messages_path(chatrooms(:upcoming)), params: { message: { content: "Hi!" } }
    end
  end
end
