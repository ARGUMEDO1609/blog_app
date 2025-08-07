class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
def create
  @post = current_user.posts.build(post_params.except(:tag_list))
  if @post.save
    save_tags
    redirect_to @post, notice: "Publicación creada."
  else
    render :new
  end
end

def update
  if @post.update(post_params.except(:tag_list))
    save_tags
    redirect_to @post, notice: "Publicación actualizada."
  else
    render :edit
  end
end


  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :body, :user_id)
    end

    def save_tags
      tags = params[:tag_list].split(',').map(&:strip).reject(&:blank?)
      @post.tags = tags.map { |name| Tag.find_or_create_by(name: name.downcase) }
    end

end
