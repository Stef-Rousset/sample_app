require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"
    assert_select "input[type=file]"
    #post invalid
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "  "} }
    end
    assert_select "div#error_explanation"
    assert_select 'a[href=?]', '/?page=2'
    #post valide
    content = "this is my new post"
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    micropost = assigns(:micropost)
    assert micropost.image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/home"
    assert_not flash.empty?
    assert_match content, response.body
    #delete post
    assert_select 'a', text: 'delete'
    micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(micropost)
    end
    #no delete link in another's user page
    get user_path(@other_user)
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
