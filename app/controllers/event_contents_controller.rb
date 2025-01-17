class EventContentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_contents = current_user.event_contents
  end

  def show
    begin
      @event_content = current_user.event_contents.find(params[:id])
    rescue
      redirect_to events_path, notice: "Conteúdo Indisponível!"
    end
  end
  def new
    @event_content = current_user.event_contents.build
  end

  def create
    @event_content = current_user.event_contents.build(event_content_params)

    if @event_content.save
      redirect_to event_contents_path, notice: "Conteúdo registrado com sucesso."
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
