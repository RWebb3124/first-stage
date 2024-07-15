class AddHeadlineToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :headline, :string
  end
end
