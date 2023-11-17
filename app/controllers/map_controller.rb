class MapController < ApplicationController
  def show
    if params[:id]
      @current_cultivar = Cultivar.find(params[:id])
    else
      @current_cultivar = nil
      @plants = Plant.all
    end 
  end
end
