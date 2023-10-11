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
    assert_seelct 'div.alert-danger'
  end
end
