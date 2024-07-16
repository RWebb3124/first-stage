class Review < ApplicationRecord
  belongs_to :booking

  validates :title, presence: true
  validates :content, presence: true, length: { minimum: 10 }
  validates :rating, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..5) }
  validates :booking_id, presence: true
end
