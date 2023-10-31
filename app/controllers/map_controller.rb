class MapController < ApplicationController
  def show
      @plants = Plant.all
      @current_cultivar = nil
  end

  def query(query_string)
    @result_plants = Plant.where("name LIKE ?", "%#{query_string}%")
    render json: @result_plants
  end

end
