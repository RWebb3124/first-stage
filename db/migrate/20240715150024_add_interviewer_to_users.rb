class AddInterviewerToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :interviewer, :boolean
  end
end
