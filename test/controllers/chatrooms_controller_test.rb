require "test_helper"

class ChatroomsControllerTest < ActionDispatch::IntegrationTest
  test "a member can open the chatroom" do
    sign_in users(:bob)

    get chatroom_path(chatrooms(:upcoming))

    assert_response :success
    assert_match messages(:hello).content, response.body
  end

  test "a stranger cannot read someone else's chat" do
    sign_in users(:carol)

    get chatroom_path(chatrooms(:upcoming))

    assert_redirected_to root_path
    assert_no_match messages(:hello).content, response.body
  end
end
