require "test_helper"

class SearchTest < ActionDispatch::IntegrationTest
  test "a search that returns many cultivars should yield a result list" do 
    get query_cultivars_path, params: {query: "a", format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }  
    assert_response :success
    assert_template 'info_panel/_search_results'
  end

  test "a search that matches 1 cultivar should yield an info panel" do 
    get query_cultivars_path, params: {query: "White Lily", format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_response :success
    assert_template 'info_panel/_revealed'
  end

  test "a search that matches no cultivars should yield an empty result list" do
    get query_cultivars_path, params: {query: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_response :success
    assert_template 'info_panel/_empty'
  end
end
