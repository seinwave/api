require "test_helper"

class CultivarTest < ActiveSupport::TestCase
  test "should return the first plant for a cultivar" do
    cultivar = cultivars(:lily)
    first_plant = plants(:plant_001)

    assert_equal first_plant, cultivar.get_first_plant
  end
end
