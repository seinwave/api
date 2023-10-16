class PlantsController < ApplicationController
  def index
    @plants = Plant.all
    render json:{ plants: @plants}
  end

  def show
  end
end
