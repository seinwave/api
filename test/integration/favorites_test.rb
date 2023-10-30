require "test_helper"

class FavoritesTest < ActionDispatch::IntegrationTest
  
   test 'should create favorite if logged-in user has NOT favorited the cultivar' do
    log_in_as(users(:matt))
    assert_difference 'Favorite.count', 1 do
      post toggle_favorite_path(cultivars(:rose))
    end
  end

  test 'should delete favorite if logged-in user has favorited the cultivar' do
    log_in_as(users(:matt))
    assert_difference 'Favorite.count', -1 do
      post toggle_favorite_path(cultivars(:rose))
    end
  end
end
