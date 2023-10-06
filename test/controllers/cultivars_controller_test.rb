require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cultivars_path
    assert_response :success
  end

end
