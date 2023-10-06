require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cultivars_index_url
    assert_response :success
  end

  test "should get show" do
    get cultivars_show_url
    assert_response :success
  end
end
