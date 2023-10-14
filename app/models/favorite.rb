class Favorite < ApplicationRecord
  belongs_to :favoriter, class_name: "User"
  belongs_to :favorite_cultivar, class_name: "Cultivar"
  validates :favoriter_id, presence: true
  validates :favorite_cultivar_id, presence: true
end
