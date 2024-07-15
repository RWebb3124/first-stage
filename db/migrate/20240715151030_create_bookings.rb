class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :meeting_link
      t.string :status
      t.references :interviewee, foreign_key: { to_table: :users }
      t.references :interviewer, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
