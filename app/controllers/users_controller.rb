class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      ## handle successful save (mailer, magic_link, token)
    else
      render 'new', status: :unprocessable_entity
    end 
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end 
end
