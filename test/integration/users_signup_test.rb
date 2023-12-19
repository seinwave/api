require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { first_name:  "",
                                         last_name: "mumpus",
                                         email: "user@invalid", } }
    end
    assert_not flash.blank?
  end

   test "valid signup information sends a magic_link login" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { first_name:  "Gramps",
        email: "user@example.com", } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.blank?
  end

end

class LoginAfterSignupTest < UsersSignup
  def setup
    super
    post users_path, params: { user: { first_name: "Valid User",
                                       email: "user@example.com",
                                       } }
    @user = assigns(:user)
  end

  test "should not log in users with an invalid login token and email" do
    get magic_link_url('no thank you', email: @user.email)
    follow_redirect!
    assert_template 'map/show'
    assert !is_logged_in?
  end

  test "should log in successfully with valid login token and email" do
    get magic_link_url(login_token: @user.login_token, email: @user.email)
    follow_redirect!
    assert_template 'map/show'
    assert is_logged_in?
  end
end 