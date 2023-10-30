require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest

  test 'favoriting links should not be visible to logged-out users' do
    get '/map'
    assert_select 'div#favorite_form', false
  end
  
end
