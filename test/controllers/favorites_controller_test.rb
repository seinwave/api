require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest

  test 'toggle favorite should require login' do
    assert_no_difference 'Favorite.count' do
      post toggle_favorite_path(cultivars(:rose))
    end
    assert_redirected_to login_url
  end
  
end
