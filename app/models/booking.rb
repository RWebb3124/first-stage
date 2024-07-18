class Booking < ApplicationRecord
  belongs_to :interviewee, class_name: 'User'
  belongs_to :interviewer, class_name: 'User'
  has_many :reviews, dependent: :destroy
end
