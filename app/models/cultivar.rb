class Cultivar < ApplicationRecord
  belongs_to :cultivar_group
  has_many :plants
  has_many :favorites,    class_name:   "Favorite",
                          foreign_key:  "cultivar_id",
                          dependent:    :destroy
end
