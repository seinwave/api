class User < ApplicationRecord
  before_save :downcase_email

  validates :first_name, presence: true, length: {maximum: 50}
  validates(:last_name, length: {maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
  format: {with: VALID_EMAIL_REGEX}, uniqueness: true


  private 

  def downcase_email
    email.downcase!
  end
  
end
