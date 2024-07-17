class ChangeColumnTypeInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :github, :string
    change_column :users, :linkedin, :string
  end
end
