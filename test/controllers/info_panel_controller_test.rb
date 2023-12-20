require "test_helper"

class InfoPanelControllerTest < ActionDispatch::IntegrationTest

  test 'should display info for a single cultivar' do 
    get info_panel_path(cultivars(:lily)), headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_template 'info_panel/info_panel_states/_single_cultivar'
  end 

  test 'should hide info panel' do
    post hide_info_panel_path, params: {format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_template 'info_panel/info_panel_states/_hidden'
  end

end
