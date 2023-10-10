class User < ApplicationRecord
  before_save :downcase_email

  validates :first_name, presence: true, length: {maximum: 50}
  validates(:last_name, length: {maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
  format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  # auth methods #
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.token = User.new_token
    update_attribute(:token_digest, User.digest(token))
  end

  def authenticated?(token)
    BCrypt::Password.new(token_digest).is_password?(token)
  end


  private 

  def downcase_email
    email.downcase!
  end

end
