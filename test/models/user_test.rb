require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Matt", last_name: "Example", email: "matt@example.com")
  end 

  test "should be valid" do
    assert @user.valid?
  end 

  test "first_name should be present" do 
    @user.first_name = " "
    assert_not @user.valid?
  end
  
  test "email should be present" do 
    @user.email = " "
    assert_not @user.valid?
  end 
end
