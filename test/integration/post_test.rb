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

  test 'posts in inverse date order' do
    get '/posts'
    assert_response :success

    a_posts = assigns(:posts)
    a_posts.to_a.each_cons(2) do |a,b|
      assert a.created_at > b.created_at, "#{b.id}:#{b.created_at} is earlier than #{a.id}:#{a.created_at}"
    end
  end
end
