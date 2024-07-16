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
  has_many :notifications
  has_many :chatrooms
  has_many :messages, through: :chatrooms
  has_many :flashcard_decks
  has_many :flashcards, through: :flashcard_decks
end
