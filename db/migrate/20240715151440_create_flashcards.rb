class CreateFlashcards < ActiveRecord::Migration[7.1]
  def change
    create_table :flashcards do |t|
      t.references :flashcard_deck, null: false, foreign_key: true
      t.string :question
      t.string :answer
      t.boolean :completed

      t.timestamps
    end
  end
end
