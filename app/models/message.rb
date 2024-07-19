class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  validates :content, presence: true
  validates :chatroom_id, presence: true

  after_create_commit do
    broadcast_append_to chatroom
  end
end
