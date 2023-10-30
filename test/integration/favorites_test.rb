require "test_helper"

class Favorites < ActionDispatch::IntegrationTest
  def setup
    @user = users(:matt)
    log_in_as(@user)
  end
end

class AddFavorite < Favorites
  def setup
    super 
  end 
  
  test 'should create favorite if logged-in user has NOT favorited the cultivar' do
   assert_difference '@user.favorite_cultivars.count', 1 do
     post add_favorite_path(cultivars(:lily), format: :turbo_stream)
   end
   assert_select "a[href=?]", delete_favorite_path(cultivars(:lily)), count: 1, text: "Unlove this cultivar"
  end
end

class UnFavorite < Favorites
  def setup
    super
    @user.favorite(cultivars(:rose)) 
  end 
  
   test 'should delete favorite if logged-in user has favorited the cultivar' do
    assert_difference '@user.favorite_cultivars.count', -1 do
      delete delete_favorite_path(cultivars(:rose), format: :turbo_stream)
    end

    assert_select "a[href=?]", add_favorite_path(cultivars(:rose)), count: 1, text: "Fave this cultivar"
  end
end 
