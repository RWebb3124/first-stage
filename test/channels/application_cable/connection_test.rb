require "test_helper"

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    test "connects a signed-in user" do
      connect env: { "warden" => FakeWarden.new(users(:bob)) }

      assert_equal users(:bob), connection.current_user
    end

    test "rejects logged-out visitors" do
      assert_reject_connection { connect env: { "warden" => FakeWarden.new(nil) } }
    end

    # Devise puts a Warden object in the Rack env; the connection only calls #user.
    FakeWarden = Struct.new(:user)
  end
end
