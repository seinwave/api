require "test_helper"

class Favorites < ActionDispatch::IntegrationTest
end


class FavoritesLoggedOut < Favorites 
  test 'favoriting links should not be visible to logged-out users' do
    get '/map'
    assert_select 'div#favorite_form', false
  end

  test 'adding favorites should not work for logged-out users' do 
    assert_no_difference 'Favorite.count' do
      post add_favorite_path(cultivars(:lily), format: :turbo_stream)
    end
  end

  test 'removing favorites should not work for logged-out users' do 
    assert_no_difference 'Favorite.count' do
      delete delete_favorite_path(cultivars(:rose), format: :turbo_stream)
    end
  end

end

class FavoritesWithLogin < Favorites
  def setup
    @user = users(:matt)
    log_in_as(@user)
  end
end 
  
class AddFavorite < FavoritesWithLogin
  def setup
    super 
  end 
  
  test 'should create favorite if logged-in user has NOT favorited the cultivar' do
   assert_difference '@user.favorite_cultivars.count', 1 do
     post add_favorite_path(cultivars(:lily), format: :turbo_stream)
   end
   assert_template 'favorites/create'
  end
end

class UnFavorite < FavoritesWithLogin
  def setup
    super
    @user.favorite(cultivars(:rose)) 
  end 
  
   test 'should delete favorite if logged-in user has favorited the cultivar' do
    assert_difference '@user.favorite_cultivars.count', -1 do
      delete delete_favorite_path(cultivars(:rose), format: :turbo_stream)
    end
    assert_template 'favorites/destroy'
  end
end 
