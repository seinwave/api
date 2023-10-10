class UserMailer < ApplicationMailer

  def magic_link
    @user = user
    mail to: user.email, subject: "Here's your BBG Roses ✨Magic Link✨!"
  end
end
