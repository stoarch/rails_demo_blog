require 'test_helper'

class PostFlowsTest < ActionDispatch::IntegrationTest
  fixtures :posts

  test 'create posts' do
    https!
    post_one = posts(:post_one)
    get '/posts/new'
    assert_response :success
    post_via_redirect '/posts', post: {title: post_one.title, content: post_one.content, author: post_one.author}
    assert_match %r|/posts/\d+|, path
    assert_equal 'Post was successfully created.', flash[:notice]
    https!(false)
    get '/posts'
    assert_response :success
    assert assigns(:posts)
  end
end
