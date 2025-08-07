class CommentsController < ApplicationController
  before_action :authenticate_user!


def create
  @commentable = find_commentable
  @comment = @commentable.comments.build(comment_params.merge(user: current_user))

  if @comment.save
  
    recipient = @commentable.user
    if recipient != current_user
      Notification.create!(
        user: recipient,
        message: "#{current_user.email} comentó tu #{ @commentable.is_a?(Post) ? 'publicación' : 'comentario' }",
        read: false
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  else
    render :new
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
