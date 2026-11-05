# frozen_string_literal: true

class ChatroomPolicy < ApplicationPolicy
  # Chatrooms the user is a member of.
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:chatroom_users).where(chatroom_users: { user: user })
    end
  end

  # Also used by ChatroomChannel to decide who may subscribe.
  def show?
    record.chatroom_users.exists?(user: user)
  end
end
