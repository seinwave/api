class Plant < ApplicationRecord
  belongs_to :cultivar

  def get_coordinates
    [self.longitude, self.latitude]
  end

end
