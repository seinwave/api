ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id   
  end 
  
end


class ActionDispatch::IntegrationTest
  def log_in_as(user)
    puts "LOGGING IN!"
    login_token = User.new_token
    user.update_attribute(:login_token_digest, User.digest(login_token))
    get magic_link_path, params: { email: user.email, login_token: login_token }
  end
end
