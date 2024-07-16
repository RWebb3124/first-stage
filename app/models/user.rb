class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings_as_interviewee, class_name: 'booking', foreign_key: :interviewee_id
  has_many :bookings_as_interviewer, class_name: 'booking', foreign_key: :interviewer_id
  has_many :reviews, through: :bookings
  has_many :user_tags
  has_many :tags, through: :user_tags
  has_many :chatrooms
  has_many :messages, through: :chatrooms
  has_many :flashcard_decks, through: :user_decks
  has_many :flashcards, through: :flashcard_decks

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true, length: { minimum: 8 }
  validates :years_experience, presence: true, if: :interviewer?
  validates :headline, presence: true, if: :interviewer?
  validates :about, presence: true, length: { minimum: 16 }, if: :interviewer?
  validates :tags, presence: true, if: :interviewer?
end

private

def interviewer?
  interviewer == true
end
