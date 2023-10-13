class SessionsController < ApplicationController

  def edit
    @user = User.find_by(email: params[:email])
    login_token = params[:id]

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
