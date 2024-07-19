class Chatroom < ApplicationRecord
  belongs_to :booking
  has_many :messages, dependent: :destroy

  validates :name, presence: true
end
