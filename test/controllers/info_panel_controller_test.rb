require "test_helper"

class InfoPanelControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get info_panel_show_url
    assert_response :success
  end

  test "should get hide" do
    get info_panel_hide_url
    assert_response :success
  end
end
