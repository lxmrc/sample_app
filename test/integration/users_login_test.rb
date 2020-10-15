require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "user@invalid.com",
                                       password: "wrong_password" } }
    assert_template 'sessions/new'
    assert_select 'div.alert-danger', 'Invalid login details.'
    get root_path
    assert flash.empty?
  end
end
