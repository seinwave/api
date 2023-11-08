require "test_helper"

class MapTest < ActionDispatch::IntegrationTest
  test "should show map" do 
    get '/map'
    assert_response :success
    assert_template 'map/show'
  end

  test "a map_data request for a cultivar should reveal an info_panel with relevant information" do 
    get info_panel_path(1, format: :turbo_stream)
    assert_response :success
    assert_template 'info_panel/_revealed'
  end
end
