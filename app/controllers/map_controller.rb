class MapController < ApplicationController
  def show
      @current_cultivar = nil
  end

  def show_with_id
    @current_cultivar = Cultivar.find(params[:id])
  end

  def show_with_query
    query_string = params[:query]
    @cultivars = Cultivar.where("name LIKE ?", "%#{query_string}%")
  end
end
