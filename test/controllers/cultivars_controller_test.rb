require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @cultivar = cultivars(:lily)
  end

  test "should get index" do
    get cultivars_path
    assert_response :success
  end

  test "exact query should return json" do
    get query_cultivars_path, params: { query: "White Lily" }
    assert_response :success
    assert_equal "application/json", @response.media_type
    parsed_body = JSON.parse(@response.body)
    assert_equal "White Lily", parsed_body[0]['name']
  end

  test "fuzzy query should return result" do
    get query_cultivars_path, params: { query: "White" }
    assert_response :success
    assert_equal "application/json", @response.media_type
    parsed_body = JSON.parse(@response.body)
    assert_equal "White Lily", parsed_body[0]['name']
  end

end
