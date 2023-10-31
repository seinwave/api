require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @cultivar = cultivars(:lily)
  end

  test "should get index" do
    get cultivars_path
    assert_response :success
  end

  test "query should return json" do
    get query_cultivars_path, params: { query: "lily" }
    assert_response :success
    assert_equal "application/json", @response.media_type
    assert_equal "[]", @response.body
  end

end
