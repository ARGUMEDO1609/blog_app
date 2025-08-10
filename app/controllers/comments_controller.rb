class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      recipient = @commentable.user
      if recipient != current_user
        Notification.create!(
          user: recipient,
          notifiable: @comment,
          message: "#{current_user.email} comentó tu #{ @commentable.is_a?(Post) ? 'publicación' : 'comentario' }",
          read: false
        )
      end

      redirect_to @commentable, notice: "Comentario creado."
    else
      render :new
    end
  end

  private

  def set_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    else
      @commentable = nil
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
