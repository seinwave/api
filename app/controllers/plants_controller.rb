class PlantsController < ApplicationController
  def index
  end

  def show
  end

  def mapped_plants
    @plants_to_map = []
    Plant.all.map do |plant|
      plant.attributes.merge(cultivar_name: Cultivar.find(plant.cultivar_id).name)
    end 
    render json: @plants_to_map
  end
end
