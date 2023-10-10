class SessionsController < ApplicationController

  def new
  end
  
  def create
    sgid = params.require(:sgid)

    user = GlobalID::Locator.locate_signed(sgid, for: 'login')
  
    if user && user.is_a?(User)
      # handle successful login
    else 
      # handle redirection
    end
  end 
end
