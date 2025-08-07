class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(5) 
  end

  def search
    query = params[:q].to_s.strip.downcase

    @posts = Post.joins("LEFT JOIN taggings ON taggings.post_id = posts.id")
                 .joins("LEFT JOIN tags ON tags.id = taggings.tag_id")
                 .where("LOWER(posts.title) LIKE ? OR LOWER(tags.name) LIKE ?", "%#{query}%", "%#{query}%")
                 .distinct

    render :index
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

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

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "Post eliminado correctamente."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end

  def save_tags
    tags = params[:tag_list].to_s.split(',').map(&:strip).reject(&:blank?)
    @post.tags = tags.map { |name| Tag.find_or_create_by(name: name.downcase) }
  end
end
