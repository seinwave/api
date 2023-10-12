require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "magic_link" do
    @user = users(:matt)
    @user.login_token = User.new_token
    mail = UserMailer.magic_link(@user)
    assert_equal "Magic link",           mail.subject
    assert_equal [@user.email],          mail.to
    assert_equal ["rosie@bbgroses.com"], mail.from
    assert_match @user.first_name,       mail.body.encoded
    assert_match @user.login_token,      mail.body.encoded
    assert_match "Hi", mail.body.encoded
  end

end
