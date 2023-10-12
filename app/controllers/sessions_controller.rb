class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    login_token = params[:id]
    if @user.authenticated_token?(:login_token, login_token)
      log_in @user
      remember @user
      redirect_to root_url
      flash[:success] = "Welcome to BBG Roses!" 
      # handle successful session
      # log in user, start session 
    else 
      redirect_to root_url
      flash[:danger] = "Invalid magic link"
    end 

  end

  def destroy
  end
end
