class User < ApplicationRecord
  ### VALIDATIONS ###
  validates :first_name, presence: true, length: {maximum:50 }
  validates :last_name, length: {maximum:50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: 255}, 
  format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  ### BEFORE METHODS ###
  before_save :downcase_email


  ### AUTHENTICATION ###
  def send_magic_link_email
      UserMailer.magic_link(self).deliver_now
  end

  private
  def downcase_email
    email.downcase!
  end

end
