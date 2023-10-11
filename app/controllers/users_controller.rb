class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    puts params
  end 
end
