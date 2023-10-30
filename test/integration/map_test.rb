require "test_helper"

class MapTest < ActionDispatch::IntegrationTest
  test "should show map" do 
    get '/map'
    assert_response :success
    assert_template 'map/show'
  end
end
