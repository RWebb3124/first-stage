class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :icon_url
      t.string :name

      t.timestamps
    end
  end
end
