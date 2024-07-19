class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings_as_interviewee, class_name: 'Booking', foreign_key: :interviewee_id
  has_many :bookings_as_interviewer, class_name: 'Booking', foreign_key: :interviewer_id
  has_many :reviews, through: :bookings
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_many :chatrooms
  has_many :messages, through: :chatrooms
  has_many :flashcard_decks, through: :user_decks
  has_many :flashcards, through: :flashcard_decks

  accepts_nested_attributes_for :tags

  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :username, presence: true, uniqueness: true
  # validates :address, presence: true, uniqueness: true, length: { minimum: 8 }
  validates :years_experience, presence: true, if: :interviewer?
  validates :headline, presence: true, if: :interviewer?
  validates :about, presence: true, length: { minimum: 16 }, if: :interviewer?
  # validates :linkedin, presence: true, if: :interviewer?
  # validates :github, presence: true, if: :interviewer?
  # validates :tags, presence: true, if: :interviewer?

  def interviewer?
    self.interviewer == true
  end

  def github?
    self.github.present?
  end

  def linkedin?
    self.linkedin.present?
  end

  def fiverr?
    self.fiverr.present?
  end

  def personal_website?
    self.personal_website.present?
  end
end
