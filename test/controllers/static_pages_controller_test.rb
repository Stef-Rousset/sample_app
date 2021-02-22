require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # the setup method is called before each test and so @title_part is available for each of the tests.
  def setup
    @title_part = "| RoR tuto sample app"
  end
  # called after every single test, re-initializing @title_part before every test
  def teardown
    @title_part = nil
  end

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home #{@title_part}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help #{@title_part}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About #{@title_part}"
  end

  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact #{@title_part}"
  end
end
