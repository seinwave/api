# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/magic_link
  def magic_link
    user = User.first 
    user.login_token = User.new_token
    UserMailer.magic_link(user)
  end

end
