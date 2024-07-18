class AddPersonalWebsiteToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :personal_website, :string
  end
end
