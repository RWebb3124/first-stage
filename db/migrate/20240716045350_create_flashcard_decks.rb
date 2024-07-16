class CreateFlashcardDecks < ActiveRecord::Migration[7.1]
  def change
    create_table :flashcard_decks do |t|
      t.string :title
      t.string :description
      t.float :completion

      t.timestamps
    end
  end
end
