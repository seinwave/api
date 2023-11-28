class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_magic_link_email
      flash[:success] = "Check your email for your Magic Login Link!"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
    else
      flash.now[:error] = "That email address is already taken bub"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
    end 
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end 
end
