class EventContentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @event_content = current_user.event_contents.build
  end

  def create
    @event_content = current_user.event_contents.build(event_content_params)

    if @event_content.save
      redirect_to root_path, notice: "Conteúdo registrado com sucesso."
    else
      flash.now[:alert] = "Falha ao registrar o conteúdo."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_content_params
    params.require(:event_content).permit(:title, :description, files: [])
  end
end
