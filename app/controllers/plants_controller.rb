class PlantsController < ApplicationController
  def index
  end

  def show
  end

  def mapped_plants
    @plants = Plant.all
    render json: @plants
  end
end
