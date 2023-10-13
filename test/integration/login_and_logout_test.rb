require "test_helper"

class LoginAndLogout < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class ValidLogin < LoginAndLogout
  def setup
    super
    user = users(:matt)
    post login_path, params: { email: user.email}
    @user = assigns(:user)
  end 
end

class LoginTest < ValidLogin

 
  test "should send a magic_link email" do 
    assert_equal 1, ActionMailer::Base.deliveries.size
  end 

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

class LogoutTest < ValidLogin

  def setup
    super 
    get magic_link_url(login_token: @user.login_token, email: @user.email)
    delete logout_path
  end

  test "should log out a user" do
    assert_response :see_other
    assert_redirected_to root_url
    assert_not is_logged_in?
  end 
  
end 

