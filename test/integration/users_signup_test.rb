require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { first_name:  "",
                                         last_name: "mumpus",
                                         email: "user@invalid", } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div.alert-danger'
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
