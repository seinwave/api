class Cultivar < ApplicationRecord
  belongs_to :cultivar_group
  has_many :plants
end
