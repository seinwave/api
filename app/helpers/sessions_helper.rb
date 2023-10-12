module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
    # guard against session replay attacks
    session[:session_token] = user.session_token
  end

  def logged_in?
    !current_user.nil?
  end 
    
  # generates tokens in the browser
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
    

end
