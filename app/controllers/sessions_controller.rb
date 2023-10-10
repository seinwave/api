class SessionsController < ApplicationController

  def new
  end
  
  def create
    sgid = params.require(:sgid)

    user = GlobalID::Locator.locate_signed(sgid, for: 'login')
  
    if user && user.is_a?(User)
      reset_session
      remember user
      log_in(user)
      redirect_to user
    else 
      flash.now[:danger] = "Invalid magic link. Please try again."
      render 'new', status: :unprocessable_entity
    end
  end 
end
