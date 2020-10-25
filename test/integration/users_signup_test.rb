require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 4 errors.' 
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    refute user.activated?
    # Try logging in before activation.
    log_in_as(user)
    refute is_logged_in?
    # Invalid activation token
    get activation_path("invalid token", email: user.email)
    refute is_logged_in?
    # Valid token, wrong email
    get activation_path(user.activation_token, email: 'wrong@email.com')
    refute is_logged_in?
    # Valid token and email
    get activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    refute flash.empty?
    assert is_logged_in?
  end
end
