module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    # Devise stores the signed-in user in Warden, which Action Cable can read
    # from the same session cookie.
    def find_verified_user
      env["warden"].user || reject_unauthorized_connection
    end
  end
end
