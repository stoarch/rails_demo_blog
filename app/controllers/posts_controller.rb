class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  MAX_CONTENT_LENGTH = 300 
  POSTS_PER_PAGE = 5

  # GET /posts
  # GET /posts.json
  def index

    res_posts = Post.select("id, title, author_id, left(content,#{MAX_CONTENT_LENGTH}) as content, created_at, published").order( created_at: :desc )

    a_parms = get_params()

    @author_id = nil

    if( a_parms[:author_id] ) #filter posts by author
      parm_author_id = a_parms[:author_id].to_i

      raise ApplicationController::NotAuthorized, 'Access denied' if !user_signed_in?
      raise ApplicationController::NotAuthorized, "Access denied to resources from another author" if( current_author_id != parm_author_id )
      @author_id = parm_author_id 
      res_posts = res_posts.where(author_id: @author_id)
    else
      res_posts = res_posts.published
    end


    @posts = res_posts.paginate(page: params[:page], per_page: POSTS_PER_PAGE)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.published = true
  end

  # GET /posts/1/edit
  def edit
    check_access_to_author_data
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    @author_id = current_user&.author&.id
    @post.author_id = @author_id
    @post.tag_list = post_params[:tag_list]

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  rescue Exception => e
    flash[:alert] = e.message
    raise
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    check_access_to_author_data

    @post.tag_list = post_params[:tag_list]

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  rescue Exception => e
    flash[:alert] = e.message
    raise
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def tag_cloud
    @tags = Post.tag_cloud
  end

  def tag
    a_parms = get_params()

    res_posts = Post.select("id, title, author_id, left(content,#{MAX_CONTENT_LENGTH}) as content, created_at, published").order( created_at: :desc )

    @author_id = nil

    res_posts = res_posts.tagged_with(a_parms[:tag], any: true)
    res_posts = res_posts.published

    @posts = res_posts.paginate(page: params[:page], per_page: POSTS_PER_PAGE)

    render action: 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :author_id, :published, :tag_list)
    end

    def get_params
      params.permit(:id, :author_id, :tag)
    end


    def check_access_to_author_data
      a_parms = get_params()
      post = Post.find(a_parms[:id])
      parm_author_id = post.author.id 

      if( current_author_id != parm_author_id )
        flash[:alert] = "Access denied"
        raise ApplicationController::NotAuthorized, flash[:alert] 
      end
    end

end
