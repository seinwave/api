class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.magic_link.subject
  #
  def magic_link(user)
    @greeting = "Hi, #{user.first_name}!"

    mail to: user.email
  end
end
