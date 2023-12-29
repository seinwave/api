class PlantsController < ApplicationController
  def index
  end

  def show
  end

  def mapped_plants
    plants = Plant.includes(:cultivar).all
    @plants_to_map = plants.map do |plant|
      plant.attributes.merge(is_favorite: is_favorite(plant.cultivar), cultivar_name: plant.cultivar.name)
    end
    render json: @plants_to_map
  end


  private 

  def is_favorite(cultivar)
    return false if !current_user
    return current_user.favorited?(cultivar)
  end
end
