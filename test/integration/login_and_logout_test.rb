require "test_helper"

class LoginAndLogout < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class LoginTest < LoginAndLogout
    def setup
    super
    post login_path, params: { email: "user@example.com"}
    @user = assigns(:user)
  end

  ##

  test "should not log in users with an invalid login token and email" do
    get magic_link_url('no thank you', email: @user.email)
    follow_redirect!
    assert_template 'cultivars/index'
    assert !is_logged_in?
    assert_not flash.blank?
    assert_select 'div.alert-danger'

  end

  test "should log in successfully with valid email" do
    get magic_link_url(login_token: @user.login_token, email: @user.email)
    follow_redirect!
    assert_template 'cultivars/index'
    assert is_logged_in?
    assert_not flash.blank?
    assert_select 'div.alert'
  end

end

