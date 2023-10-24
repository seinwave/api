class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    cultivar = Cultivar.find(params[:favorite_cultivar_id])
    current_user.favorite(cultivar)
  end 

  def destroy
    puts 'DESTROYING!'
    cultivar_id = Favorite.find(params[:id]).favorite_cultivar_id
    cultivar = Cultivar.find(cultivar_id)
    current_user.unfavorite(cultivar)
  end 
end
