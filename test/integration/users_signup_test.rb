require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid form should not increase the total of users" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user:  { name: "jonathan", email: "jonathan@gmail.com",
                                          password: "foo",
                                          password_confirmation: "foo"} }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "li", "Password is too short (minimum is 6 characters)"
    assert_select "div.field_with_errors"
  end

  test "valid form should increase the total of users by 1" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "jonathan", email: "jonathan@gmail.com",
                                          password: "foobar",
                                          password_confirmation: "foobar"} }
    end
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
