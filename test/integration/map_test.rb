require "test_helper"

class MapTest < ActionDispatch::IntegrationTest

  test "should show map" do 
    get '/map'
    assert_response :success
    assert_template 'map/show'
  end

  test "a map_data request for plants should return a json object" do
    get map_data_plants_path
    assert_response :success
    assert_equal "application/json", @response.media_type
  end 

  test "a map_data request for a cultivar should reveal an info_panel with relevant information" do 
    get info_panel_path(1, format: :turbo_stream), headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_response :success
    assert_template 'info_panel/_revealed'
  end

  test "a map#show_with_id request should reveal an info_panel with relevant information" do
    get map_with_id_path(1)
    assert_response :success
    assert_template 'info_panel/_revealed'
  end

  test "a map#show_with_query request should reveal an info_panel with relevant information" do
    get map_with_query_path("A")
    assert_response :success
    assert_template 'info_panel/_search_results'
  end

  test "a map#show_with_id for a Cultivar that doesn't exist should 404" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get map_with_id_path(1000000)
    end
  end
end
