class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  # Broadcasts go through Postgres NOTIFY, which caps each payload at 8000
  # bytes. HTML + JSON escaping can turn one typed "&" into 10 bytes, so 700
  # characters is the most that always fits (measured, worst case ~7.5KB).
  MAX_LENGTH = 700

  validates :content, presence: true, length: { maximum: MAX_LENGTH }
  validates :chatroom_id, presence: true

  after_create_commit do
    broadcast_append_to chatroom, target: "messages"
  end

  def sender?(some_user)
    user == some_user
  end
end
