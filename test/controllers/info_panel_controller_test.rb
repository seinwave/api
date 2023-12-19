require "test_helper"

class InfoPanelControllerTest < ActionDispatch::IntegrationTest

  test 'should display info panel' do 
    puts 'CULTIVAR IS:', cultivars(:lily)
    get info_panel_path(cultivars(:lily)), headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_template 'info_panel/_cultivar_info'
  end 

  test 'should hide info panel' do
    post hide_info_panel_path, params: {format: :turbo_stream}, headers: { "HTTP_REFERER" => "http://bbgroses-test.com" }
    assert_template 'info_panel/_hidden'
  end

end
