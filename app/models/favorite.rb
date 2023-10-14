class Favorite < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :favorite, class_name: "Favorite"
end
