class Booking < ApplicationRecord
  belongs_to :interviewee, class_name: 'User'
  belongs_to :interviewer, class_name: 'User'
  has_many :reviews, dependent: :destroy
  has_one :chatroom, dependent: :destroy

  validates :start_time, :end_time, presence: true

  after_create :create_chatroom

  default_scope -> { order(:start_time) }  # Our meetings will be ordered by their start_time by default

  def time
    "#{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}"
  end

  def time_full
    "#{start_time.strftime("%A, %b #{start_time.day.ordinalize} ")}"

  end

  def multi_days?
    (end_time.to_date - start_time.to_date).to_i >= 1
  end

  private

  def create_chatroom
    chatroom = Chatroom.create(name: , booking: self)
    ChatroomUser.create(chatroom: chatroom, user: self.interviewer)
    ChatroomUser.create(chatroom: chatroom, user: self.interviewee)
  end
end
