require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = authors(:paul).posts[0] 
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

  test 'should redirect anonymous user to login' do
    post :create, post: { author_id: @post.author_id, content: @post.content, title: @post.title }
    assert_response :redirect
    assert_match 'sign_in', response.body
  end

  test "should create post" do
    sign_in users(:user_paul)
    assert_difference(->{Post.count}) do
      post :create, post: { author_id: authors(:paul).id, content: @post.content, title: @post.title }
    end

    assert_equal authors(:paul).id, assigns(:post).author_id, 'Author should be same as logged user'

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

  test 'should warn when editing another author post' do
    sign_in users(:user_paul)
    get :edit, id: authors(:john).posts[0].id 
    assert_equal 'Access denied', flash[:alert]
    assert_response :forbidden
  end

  test "should update post" do
    sign_in users(:user_paul)
    patch :update, id: @post, post: { author_id: @post.author_id, content: @post.content, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test 'should warn when updating another author post' do
    sign_in users(:user_paul)
    patch :update, id: authors(:john).posts[0].id, post: { author_id: @post.author_id, content: @post.content, title: @post.title }

    assert_equal 'Access denied', flash[:alert]
    assert_response :forbidden
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

  test 'post by author inacessible to anonymous' do
    fix_author = authors(:john)
    assert_not_nil fix_author, 'John Doe does not defined in fixtures'

    get :index, author_id: fix_author.id 

    assert_response :forbidden
    assert_not_nil flash[:alert], 'Should not access to other author resources'
    assert_equal 'Access denied', flash[:alert], 'Alert does not display valid info'
  end

  test 'post by author inacessible to another user' do
    sign_in users(:user_paul)

    fix_author = authors(:john)
    assert_not_nil fix_author, 'John Doe does not defined in fixtures'

    get :index, author_id: fix_author.id 

    assert_response :forbidden
    assert_not_nil flash[:alert], 'Should not access to other author resources'
    assert_equal 'Access denied to resources from another author', flash[:alert], 'Alert does not display valid info'
  end

  test 'post filtered by author' do
    sign_in users(:user_john)

    fix_author = authors(:john)
    assert_not_nil fix_author, 'John Doe does not defined in fixtures'

    get :index, author_id: fix_author.id 
    assert_nil flash[:alert], 'Should access to self resources'
    assert_response :success

    a_posts = assigns(:posts)
    assert_not_nil a_posts
    assert_equal  fix_author.posts.size, a_posts.all.size, 'Author posts not filtered'
  end
    
end
