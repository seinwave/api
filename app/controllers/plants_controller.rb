class PlantsController < ApplicationController
  def index
  end

  def show
  end

  def mapped_plants
    @plants_to_map = Plant.all.map do |plant|
      plant.attributes.merge(cultivar_name: Cultivar.find(plant.cultivar_id).name)
      plant.attributes.merge(is_favorite: is_favorite(Cultivar.find(plant.cultivar_id)))
    end 
    render json: @plants_to_map
  end

  private 

  def is_favorite(cultivar)?
    return false if !current_user
    return current_user.favorited?(cultivar)
  end
end
