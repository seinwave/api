class Plant < ApplicationRecord
  belongs_to :cultivar

  def get_coordinates
    [self.latitude, self.longitude]
  end

end
