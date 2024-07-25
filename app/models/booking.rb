class Booking < ApplicationRecord
  belongs_to :interviewee, class_name: 'User'
  belongs_to :interviewer, class_name: 'User'
  has_many :reviews, dependent: :destroy
  has_one :chatroom, dependent: :destroy

  validate :start_time_in_future
  validate :end_time_after_start_time

  default_scope -> { order(:start_time) }

  def start_time_in_future
    errors.add(:start_time, "must be in the future") if start_time.present? && start_time < Time.current
  end

  def end_time_after_start_time
    errors.add(:end_time, "must be after start time") if start_time.present? && end_time.present? && start_time >= end_time
  end

  after_create :create_chatroom

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
    chatroom = Chatroom.create(name:  "#{self.id}", booking: self)
    ChatroomUser.create(chatroom: chatroom, user: self.interviewer)
    ChatroomUser.create(chatroom: chatroom, user: self.interviewee)
  end
end
