require "test_helper"

class SearchTest < ActionDispatch::IntegrationTest
  test "a search that returns many cultivars should yield a result list" do 
    post result_panel_path, params: {query: "a", format: :turbo_stream}
    assert_response :success
  end
end
