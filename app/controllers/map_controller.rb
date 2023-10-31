class MapController < ApplicationController
  def show
      @plants = Plant.all
      @current_cultivar = nil
  end

end
