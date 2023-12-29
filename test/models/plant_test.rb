require "test_helper"

class PlantTest < ActiveSupport::TestCase
  
  test "should return a plant's coordinates" do
    plant = plants(:plant_001)
    assert_equal [plant.latitude, plant.longitude], plant.get_coordinates
  end
end
