require "test_helper"

class MapControllerTest < ActionDispatch::IntegrationTest

  test "should get show" do
    get "/map"
    assert_response :success
    assert_select "div#map-container"
  end

  test "query should return json" do
    get "/map_data/plants?query=jude"
    assert_response :success
    assert_equal "application/json", @response.media_type
    puts @response.body
    assert_equal "[]", @response.body
  end
end
