class AddBookingToChatrooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :chatrooms, :booking, null: false, foreign_key: true
    remove_reference :chatrooms, :user, null: false, foreign_key: true
  end
end
