require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "magic_link" do
    @user = users(:matt)
    mail = UserMailer.magic_link(@user)
    assert_equal "Magic link", mail.subject
    assert_equal ["mseidholz@gmail.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
