require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "magic_link" do
    @user = users(:matt)
    mail = UserMailer.magic_link(@user)
    assert_equal "Magic link", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["from@example.com"],  mail.from
    assert_match user.name,             mail.body.encoded
    asser_match user.login_token,       mail.body.encoded
    assert_match "Hi", mail.body.encoded
  end

end
