require "test_helper"

class CultivarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @cultivar = cultivars(:lily)
  end

  test "should get index" do
    get cultivars_path
    assert_response :success
  end

  test "should get show" do
    get cultivar_path(@cultivar)
    assert_response :success
    assert_template 'cultivars/show'
  end

end
