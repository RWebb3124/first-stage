require "test_helper"

# The real Devise forms (the other tests use the sign_in shortcut, which
# skips them). Catches breakage from Devise or Rails upgrades.
class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "real login form signs in" do
    post user_session_path, params: { user: { email: users(:bob).email, password: "password" } }
    assert_redirected_to root_path
    follow_redirect!
    assert_select "#navbarDropdown"
  end

  test "wrong password re-renders with 422" do
    post user_session_path, params: { user: { email: users(:bob).email, password: "nope" } }
    assert_response :unprocessable_content
    assert_match "Invalid", response.body
  end

  test "sign up creates an account" do
    assert_difference "User.count", 1 do
      post user_registration_path, params: { user: { email: "new@example.com", password: "secret123", password_confirmation: "secret123",
                                                       first_name: "New", last_name: "Person", address: "1 Road", username: "newbie" } }
    end
    assert_response :see_other
  end

  test "invalid sign up shows errors" do
    post user_registration_path, params: { user: { email: "", password: "x" } }
    assert_response :unprocessable_content
    assert_select "#error_explanation, .invalid-feedback"
  end

  test "logout" do
    sign_in users(:bob)
    delete destroy_user_session_path
    assert_response :see_other
  end
end
