class ReactionsController < ApplicationController
  before_action :authenticate_user!

def create
  @reactable = find_reactable
  @reaction = @reactable.reactions.build(user: current_user)

  if @reaction.save
    # Crear notificación si no reacciona sobre sí mismo
    recipient = @reactable.user
    if recipient != current_user
      Notification.create!(
        user: recipient,
        message: "#{current_user.email} reaccionó a tu #{ @reactable.is_a?(Post) ? 'publicación' : 'comentario' }",
        read: false
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  else
    redirect_back fallback_location: root_path, alert: "No se pudo guardar la reacción"
  end
end


  private

  def find_reactable
    params[:reactable_type].constantize.find(params[:reactable_id])
  end
end
