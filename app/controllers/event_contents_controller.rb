class EventContentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_contents = current_user.event_contents
  end

  def show
    begin
      @event_content = set_event_content
    rescue
      redirect_to events_path, notice: "Conteúdo Indisponível!"
    end
  end
  def new
    @event_content = current_user.event_contents.build
  end

  def create
    @event_content = current_user.event_contents.build(event_content_params)
    @event_content.files = params[:event_content][:files]

    if @event_content.save
      redirect_to @event_content, notice: "Conteúdo registrado com sucesso."
    else
      flash.now[:alert] = "Falha ao registrar o conteúdo."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    begin
      @event_content = set_event_content
    rescue
      redirect_to events_path, notice: "Conteúdo Indisponível!"
    end
  end

  def update
    @event_content = set_event_content
    @event_content.files.attach(params[:event_content][:files])

    if @event_content.update(event_content_params)
      redirect_to @event_content, notice: "Conteúdo atualizado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível atualizar seu Conteúdo."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_content_params
    params.require(:event_content).permit(:title, :description)
  end

  def set_event_content
    current_user.event_contents.find(params[:id])
  end
end
