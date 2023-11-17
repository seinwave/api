require "test_helper"

class InfoPanelControllerTest < ActionDispatch::IntegrationTest

  test 'should display info panel' do 
    get info_panel_path(cultivars(:lily)), headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_template 'info_panel/_revealed'
  end 

end
