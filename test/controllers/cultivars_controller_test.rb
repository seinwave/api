require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @cultivar = cultivars(:lily)
  end

  test "should get index" do
    get cultivars_path
    assert_response :success
  end

  test "null result should render empty info panel" do
    get query_cultivars_path(params: { query: "Baby Beluga" }, format: :turbo_stream), headers: { "HTTP_REFERER" => "http://bbgroses-test.com" } 
    assert_response :success
    assert_template 'info_panel/_empty'
  end

  test "single result should render info panel" do
    get query_cultivars_path, params: { query: "White Lily" , format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }  
    assert_response :success
    assert_template 'info_panel/_revealed'
  end

  test "multiple results should render result panel" do
    get query_cultivars_path, params: { query: "White" , format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }  
    assert_response :success
    assert_template 'info_panel/_search_results'
  end 
end
