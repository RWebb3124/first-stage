class AddGithubToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :github, :text
  end
end
