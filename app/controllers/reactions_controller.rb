class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    reactionable = find_reactionable

      @reaction = reactionable.reactions.find_or_initialize_by(user: current_user)
      @reaction.reaction_type = params[:reaction_type]

    if @reaction.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Reaction recorded." }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "The reaction could not be recorded." }
      end
    end
  end

  private

  def find_reactionable
    params[:reactable_type].constantize.find(params[:reactable_id])
  end
end
