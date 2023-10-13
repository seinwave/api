class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.send_magic_link_email
      redirect_to root_url
      flash[:info] = "Check your email for your Magic Login Link!"
    else 
      flash[:danger] = "No account associated with that email, bub"
    end 
  end 

  def edit
    @user = User.find_by(email: params[:email])
    login_token = params[:login_token]

    if @user && @user.authenticated_token?(:login_token, login_token)
      log_in @user
      remember @user
      redirect_to root_url
      flash[:success] = "Welcome to BBG Roses!" 
    else
      redirect_to root_url
      flash[:danger] = "Invalid magic link"
    end 
  end

end
