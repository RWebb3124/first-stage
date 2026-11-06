class BackfillAndDefaultBookingStatus < ActiveRecord::Migration[7.1]
  # Pending bookings used to be stored as NULL. Give them a real value so the
  # status column can be a non-null enum.
  def up
    execute "UPDATE bookings SET status = 'pending' WHERE status IS NULL"
    change_column_default :bookings, :status, "pending"
    change_column_null :bookings, :status, false
  end

  def down
    change_column_null :bookings, :status, true
    change_column_default :bookings, :status, nil
    execute "UPDATE bookings SET status = NULL WHERE status = 'pending'"
  end
end
