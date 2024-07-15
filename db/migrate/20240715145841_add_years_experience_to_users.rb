class AddYearsExperienceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :years_experience, :integer
  end
end
