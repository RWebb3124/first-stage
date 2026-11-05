# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  # Anyone who can see the chatroom can post in it.
  def create?
    ChatroomPolicy.new(user, record.chatroom).show?
  end
end
