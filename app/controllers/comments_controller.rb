class CommentsController < ApplicationController
  before_action :authenticate_user!

# app/controllers/comments_controller.rb
def create
  @commentable = find_commentable
  @comment = @commentable.comments.build(comment_params)
  @comment.user = current_user

  if @comment.save
    # Crear notificación si se comenta una publicación ajena
    if @commentable.is_a?(Post) && @commentable.user != current_user
      Notification.create!(
        user: @commentable.user,
        notifiable: @comment,
        message: "#{current_user.email} comentó tu publicación."
      )
    end

    redirect_to @commentable, notice: "Comentario creado."
  else
    render partial: "comments/form", locals: { commentable: @commentable }
  end
end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    if params[:post_id]
      Post.find(params[:post_id])
    else
      Comment.find(params[:comment_id])
    end
  end

  def find_post(commentable)
    return commentable if commentable.is_a?(Post)
    find_post(commentable.commentable)
  end
end
