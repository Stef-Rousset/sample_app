require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "RoR tuto sample app"
    assert_equal full_title("Help"), "Help | RoR tuto sample app"
  end
end
