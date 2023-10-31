require "test_helper"

class MapControllerTest < ActionDispatch::IntegrationTest

  test "should get show" do
    get "/map"
    assert_response :success
    assert_select "div#map-container"
  end

end
