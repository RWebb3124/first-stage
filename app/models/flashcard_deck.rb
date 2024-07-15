class FlashcardDeck < ApplicationRecord
  belongs_to :user
  has_many :flashcards
end
