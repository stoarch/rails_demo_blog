require 'test_helper'

class PostFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :posts

  test 'create posts' do
    https!
    sign_in users(:user_paul)
    post_one = posts(:post_one)
    get '/posts/new'
    assert_response :success
    post_via_redirect '/posts', post: {title: post_one.title, content: post_one.content, author: post_one.author, published: true}
    assert_match %r|/posts|, path
    assert_nil flash[:alert], 'No errors should be here'
    assert_equal 'Post was successfully created.', flash[:notice]
    https!(false)
    get '/posts'
    assert_response :success
    assert assigns(:posts)
  end

end
