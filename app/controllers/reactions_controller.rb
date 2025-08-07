class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @reactable = find_reactable
    @reaction = @reactable.reactions.find_or_initialize_by(user: current_user, kind: params[:kind])

    if @reaction.persisted?
      @reaction.destroy
    else
      @reaction.save
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def find_reactable
    params[:reactable_type].constantize.find(params[:reactable_id])
  end
end
