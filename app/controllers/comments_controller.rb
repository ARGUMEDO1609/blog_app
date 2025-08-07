class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(find_post(@commentable)), notice: "Comentario creado." }
      end
    else
      render turbo_stream: turbo_stream.replace("comment_form_#{dom_id(@commentable)}", partial: "comments/form", locals: { commentable: @commentable, comment: @comment })
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
