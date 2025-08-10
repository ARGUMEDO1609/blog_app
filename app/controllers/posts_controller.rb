class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(5)
  end

def search
  @posts = Post.where("title ILIKE ?", "%#{params[:q]}%")
               .page(params[:page])
               .per(10)
end


  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      save_tags
      redirect_to @post, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params.except(:tag_list))
      save_tags
      redirect_to @post, notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "Post successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :tag_list)
  end

  def save_tags
    tags = params[:tag_list].to_s.split(',').map(&:strip).reject(&:blank?)
    @post.tags = tags.map { |name| Tag.find_or_create_by(name: name.downcase) }
  end
end

