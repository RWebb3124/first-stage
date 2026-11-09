require "test_helper"

class ChatPoliciesTest < ActiveSupport::TestCase
  test "chatroom members can see it, strangers cannot" do
    chatroom = chatrooms(:upcoming)

    assert ChatroomPolicy.new(users(:alice), chatroom).show?
    assert ChatroomPolicy.new(users(:bob), chatroom).show?
    assert_not ChatroomPolicy.new(users(:carol), chatroom).show?
  end

  test "chatroom scope only lists the user's rooms" do
    assert_equal 2, ChatroomPolicy::Scope.new(users(:alice), Chatroom).resolve.count
    assert_empty ChatroomPolicy::Scope.new(users(:carol), Chatroom).resolve
  end

  test "only members can post messages" do
    message = Message.new(chatroom: chatrooms(:upcoming))

    assert MessagePolicy.new(users(:bob), message).create?
    assert_not MessagePolicy.new(users(:carol), message).create?
  end
end
