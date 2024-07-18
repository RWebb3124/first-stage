class AddFiverrToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :fiverr, :string
  end
end
