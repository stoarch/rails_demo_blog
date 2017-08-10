class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @post = Post.find(index_params[:post_id])
    @comments = @post.comments 

    respond_to do |format|
      format.html
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    post = Post.find(index_params[:post_id])
    @comment = post.comments.build
    @comment.author_id = current_author_id
    @comment
  rescue Exception => e
    flash[:alert] = e.message
    raise
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    post = Post.find(comment_params[:post_id])
    @comment = post.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@comment.post), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue Exception => ex
    flash[:alert] = ex.message
    raise
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    post = Post.find(update_params[:post_id])
    @comment = post.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(update_params)
        format.html { redirect_to post_path(@comment.post), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue Exception => e
    flash[:alert] = e.message
    raise
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    post = Post.find(destroy_params[:post_id])
    @comment = post.comments.find(destroy_params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to post_comments_url(post), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue Exception => e
    flash[:alert] = e.message
    raise
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:id, :content, :author_id, :post_id)
    end

    def index_params
      params.permit(:content, :author_id, :post_id)
    end

    def destroy_params
      params.permit(:id, :content, :author_id, :post_id)
    end

    def update_params
      params.require(:comment).permit(:id, :content, :author_id, :post_id)
    end
end
