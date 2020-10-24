require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links when not logged in' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a', text: 'Account', count: 0
    get login_path
    assert_select "title", full_title("Log in")
    assert_template "sessions/new"
    get help_path
    assert_select "title", full_title("Help")
    get about_path
    assert_select "title", full_title("About")
    get contact_path
    assert_select "title", full_title("Contact")
  end

  test 'layout links when logged in' do
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a', text: 'Account'
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', logout_path
    get help_path
    assert_select "title", full_title("Help")
    get about_path
    assert_select "title", full_title("About")
    get contact_path
    assert_select "title", full_title("Contact")
    get users_path
    assert_select "title", full_title("All users")
    assert_template "users/index"
    get user_path(@user)
    assert_select "title", full_title(@user.name)
    assert_template "users/show"
    get edit_user_path(@user)
    assert_select "title", full_title("Edit user")
    assert_template "users/edit"
    delete logout_path
    assert_redirected_to root_url
  end
end
