require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  
  def setup
    @favorite = Favorite.new(user_id: users(:matt).id,
                            cultivar_id: cultivars(:lily).id)
  end

  test "should be valid" do
    assert @favorite.valid?
  end

  test "should require a cultivar_id" do
    @favorite.cultivar_id = nil
    assert_not @favorite.valid?
  end

  test "should require a user_id" do
    @favorite.user_id = nil
    assert_not @favorite.valid?
  end
end
