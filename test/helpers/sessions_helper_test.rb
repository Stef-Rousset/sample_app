require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil (in the remember me case)" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    #on donne une nouvelle valeur a remember_digest qui sera donc differente de celle de @user
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    #current_user sera donc nil
    assert_nil current_user
  end
end
