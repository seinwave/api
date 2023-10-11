class User < ApplicationRecord
  attr_accessor :login_token

  ### VALIDATIONS ###
  validates :first_name, presence: true, length: {maximum:50 }
  validates :last_name, length: {maximum:50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: 255}, 
  format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  ### BEFORE METHODS ###
  before_save :downcase_email
  before_create :create_login_digest


  ### AUTHENTICATION ###
  class << self 
    def send_magic_link_email
        UserMailer.magic_link(self).deliver_now
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:cost)
    end
  end   

  private
  def downcase_email
    email.downcase!
  end

  def create_login_digest
    self.login_token = User.new_token
    self.login_token_digest = User.digest(login_token)
  end

end
