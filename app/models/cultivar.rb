class Cultivar < ApplicationRecord
  belongs_to :cultivar_group
  has_many :plants
  has_many :favorites,    class_name:   "Favorite",
                          foreign_key:  "favorite_cultivar_id",
                          dependent:    :destroy
  has_many :favoriters, through: :favorites, source: :favoriter

  def global_favorite_count 
    Favorite.where(favorite_cultivar_id: self.id).count
  end

  def global_plant_count
    Plant.where(cultivar_id: self.id).count
  end

  def get_first_plant
    Plant.where(cultivar_id: self.id).first
  end

  def get_first_plant_coordinates
    self.get_first_plant.get_coordinates
  end

end
