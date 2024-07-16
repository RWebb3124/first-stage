class UserDeck < ApplicationRecord
  belongs_to :user
  belongs_to :flashcard_deck
end
