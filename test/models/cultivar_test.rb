require "test_helper"

class CultivarTest < ActiveSupport::TestCase

  test "should return a count of favorites for a cultivar" do
    cultivar = cultivars(:lily)
    assert_equal 1, cultivar.global_favorite_count
  end

  test 'should return a count of plants for a cultivar' do
    cultivar = cultivars(:lily)
    assert_equal 1, cultivar.global_plant_count
  end
  
  test "should return the first plant for a cultivar" do
    cultivar = cultivars(:lily)
    first_plant = plants(:plant_001)

    assert_equal first_plant, cultivar.get_first_plant
  end

  test "should return the first plant's coordinates for a cultivar" do
    cultivar = cultivars(:lily)
    first_plant = plants(:plant_001)

    assert_equal first_plant.get_coordinates, cultivar.get_first_plant_coordinates
  end
end
