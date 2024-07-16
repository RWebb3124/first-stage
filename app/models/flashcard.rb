class Flashcard < ApplicationRecord
  belongs_to :flashcard_deck

  validates :flashcard_deck_id, presence: true
end
