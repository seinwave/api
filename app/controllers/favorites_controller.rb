class FavoritesController < ApplicationController
  before_action :logged_in_user

  def update
    cultivar = Cultivar.find(params[:favorite_cultivar_id])
    respond_to do |format|
      format.html { redirect_to '/map'}
      format.turbo_stream
    end
  end 

  def create
    @cultivar = Cultivar.find(params[:favorite_cultivar_id])
    @current_cultivar = @cultivar
    current_user.favorite(@cultivar)
    respond_to do |format|
      format.html { redirect_to '/map'}
      format.turbo_stream
    end
  end 

  def destroy
    @cultivar = Cultivar.find(params[:id])
    current_user.unfavorite(@cultivar)
    respond_to do |format|
      format.html { redirect_to '/map' }
      format.turbo_stream
    end
  end 
end
