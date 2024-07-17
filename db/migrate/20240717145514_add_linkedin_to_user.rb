class AddLinkedinToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :linkedin, :text
  end
end
