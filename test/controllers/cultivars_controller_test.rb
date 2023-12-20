require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @cultivar = cultivars(:lily)
  end

  test "should get index" do
    get cultivars_path
    assert_response :success
  end

  test "should return a count of favorites for a cultivar" do
    assert_equal 1, @cultivar.global_favorite_count
  end

  test "should return a count of plants for a cultivar" do
    assert_equal 1, @cultivar.global_plant_count
  end

  test "null result should render the empty search result state" do
    get query_cultivars_path(params: { query: "Baby Beluga" }, format: :turbo_stream), headers: { "HTTP_REFERER" => "http://bbgroses-test.com" } 
    assert_response :success
    assert_template 'info_panel/info_panel_states/_empty'
  end

  test "single result should render info for a single cultivar" do
    get query_cultivars_path, params: { query: "White Lily" , format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }  
    assert_response :success
    assert_template 'info_panel/info_panel_states/_single_cultivar'
  end

  test "multiple results should render search results panel state" do
    get query_cultivars_path, params: { query: "White" , format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }  
    assert_response :success
    assert_template 'info_panel/info_panel_states/_search_results'
  end
  
end
