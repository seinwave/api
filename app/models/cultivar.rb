class Cultivar < ApplicationRecord
  belongs_to :cultivar_group
  has_many :plants
  has_many :favorites,    class_name:   "Favorite",
                          foreign_key:  "favorite_cultivar_id",
                          dependent:    :destroy
  has_many :favoriters, through: :favorites, source: :favoriter

end
