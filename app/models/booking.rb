class Booking < ApplicationRecord
  belongs_to :interviewee, class_name: 'User'
  belongs_to :interviewer, class_name: 'User'
  has_many :reviews, dependent: :destroy
  has_many :chatrooms, dependent: :destroy

  validates :start_time, :end_time, presence: true

  default_scope -> { order(:start_time) }  # Our meetings will be ordered by their start_time by default

  def time
    "#{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")}"
  end

  def multi_days?
    (end_time.to_date - start_time.to_date).to_i >= 1
  end
end
