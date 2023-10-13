class User < ApplicationRecord
  attr_accessor :login_token, :remember_token

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
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:cost)
    end
  end 
  
    def send_magic_link_email
      UserMailer.magic_link(self).deliver_now
    end

    def send_login_magic_link_email
      update_login_digest
      UserMailer.magic_link(self).deliver_now
    end

    # generates token and token digest for user model
    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_token_digest,
      User.digest(remember_token))
      remember_token_digest
    end

    def session_token
      remember_token_digest || remember
    end
     
    def authenticated_token?(attribute, token)
      digest = send("#{attribute}_digest")
      puts 'AUTHENTICATING WITH'
      puts digest
      puts login_token
      return false if digest.nil?
      puts "BCRYPT:", BCrypt::Password.new(digest).is_password?(token)
      BCrypt::Password.new(digest).is_password?(token)
    end

  

  private
  def downcase_email
    email.downcase!
  end

  def create_login_digest
    self.login_token = User.new_token
    self.login_token_digest = User.digest(login_token)
  end

  def update_login_digest
    self.login_token = User.new_token
      update_attribute(:login_token_digest, User.digest(login_token))
  end


end
