require "test_helper"

class SearchTest < ActionDispatch::IntegrationTest
  test "a search that returns many cultivars should yield a result list" do 
    get query_cultivars_path, params: {query: "a", format: :turbo_stream}
    assert_response :success
    assert_template 'info_panel/_search_results'
  end
end
