require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @author = authors(:paul)
    @comment = comments(:paul_comment_one) 
  end

  test "should get index" do
    get :index, { post_id: @comment.post_id }
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    sign_in users(:user_paul)
    get :new,  post_id: @comment.post_id 
    assert_nil flash[:alert], 'No errors should be created'
    assert_not_nil assigns(:comment)
    assert_equal [], assigns(:comment).errors.full_messages
    assert_equal @comment.author_id, assigns(:comment).author_id
    assert_response :success
  end

  test "should create comment" do
    sign_in users(:user_paul)
    assert_difference(->{Comment.count}) do
      post :create, comment: { author_id: @comment.author_id, content: @comment.content, post_id: @comment.post_id }
    end

    assert_redirected_to post_path(assigns(:comment).post_id)
  end

  test "should show comment" do
    get :show, id: @comment
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_paul)
    get :edit, id: @comment
    assert_response :success
  end

  test "should update comment" do
    sign_in users(:user_paul)
    patch :update, id: @comment, comment: { id: @comment.id, author_id: @comment.author_id, content: @comment.content, post_id: @comment.post_id }

    assert_equal [], assigns(:comment).errors.full_messages 
    assert_nil flash[:alert], 'No errors on update expected'
    assert_equal 'Comment was successfully updated.', flash[:notice]

    assert_redirected_to post_path(@comment.post_id)
  end

  test "should destroy comment" do
    sign_in users(:user_paul)
    assert_difference('Comment.count', -1) do
      delete :destroy,  id: @comment.id, author_id: @comment.author_id, content: @comment.content, post_id: @comment.post_id 

      assert_equal [], assigns(:comment).errors.full_messages 
      assert_nil flash[:alert], 'No errors on destroy expected'
      assert_equal 'Comment was successfully destroyed.', flash[:notice]
    end

    assert_redirected_to post_path(@comment.post_id)
  end

end
