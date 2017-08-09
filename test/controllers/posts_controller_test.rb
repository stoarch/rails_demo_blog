require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    sign_in users(:user_paul)
    get :new
    assert_response :success
  end

  test "should create post" do
    sign_in users(:user_paul)
    assert_difference('Post.count') do
      post :create, post: { author_id: @post.author_id, content: @post.content, title: @post.title }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_paul)
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    sign_in users(:user_paul)
    patch :update, id: @post, post: { author_id: @post.author_id, content: @post.content, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    sign_in users(:user_paul)
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end

  test 'posts in inverse date order' do
    get :index
    assert_response :success

    a_posts = assigns(:posts)
    a_posts.to_a.each_cons(2) do |a,b|
      assert a.created_at > b.created_at, "#{b.id}:#{b.created_at} is earlier than #{a.id}:#{a.created_at}"
    end
  end

  MAX_POST_LENGTH = 300 

  test "post content is no longer than #{MAX_POST_LENGTH}" do
    get :index
    assert_response :success

    a_posts = assigns(:posts)
    assert_not_nil a_posts
    a_posts.each do |p|
      assert_operator p.content.length, :<=, MAX_POST_LENGTH, "#{p.id} content too long"
    end
  end


  test 'post filtered by author' do
    fix_author = authors(:john)
    assert_not_nil fix_author, 'John Doe does not defined in fixtures'

    get :index, author_id: fix_author.id 
    assert_response :success

    a_posts = assigns(:posts)
    assert_not_nil a_posts
    assert_equal  fix_author.posts.size, a_posts.all.size, 'Author posts not filtered'
  end
    
end
