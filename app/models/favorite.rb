class Favorite < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :cultivar, class_name: "Cultivar"
end
