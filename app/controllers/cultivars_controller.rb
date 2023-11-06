class CultivarsController < ApplicationController
  def index
    @cultivars = Cultivar.all
  end

  def show
    @cultivar = Cultivar.find(params[:id])
    render json: @cultivar
  end

  def query
    query_string = params[:query]
    @cultivars = Cultivar.where("name LIKE ?", "%#{query_string}%")
    respond_to do |format|
       format.turbo_stream
    end
  end

end
