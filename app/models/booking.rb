class Booking < ApplicationRecord
  belongs_to :interviewee, class_name: ‘user’
  belongs_to :interviewer, class_name: ‘user’
  has_many :reviews
end
