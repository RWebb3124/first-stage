class UserDeck < ApplicationRecord
  belongs_to :user
  belongs_to :flashcard_deck

  validates :user_id, presence: true, uniqueness: { scope: :flashcard_deck_id }
  validates :flashcard_deck_id, presence: true
end
