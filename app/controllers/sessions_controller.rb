class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.send_login_magic_link_email
      flash.now[:success] = "Check your email for your BBG Magic Link!"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
    else 
      flash.now[:error] = "That email address ain't familiar bub"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
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

  def destroy
    log_out 
    redirect_to root_url, status: :see_other
  end 

end
