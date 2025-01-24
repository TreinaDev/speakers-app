class EventContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_content, only: %i[ show edit update ]
  before_action :set_event_content_files, only: %i[ edit update ]

  def index
    @event_contents = current_user.event_contents
  end

  def show; end

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

  def edit; end

  def update
    @event_content.files = params[:event_content][:files]
    if @event_content.update(event_content_params)
      redirect_to @event_content, notice: "Conteúdo atualizado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível atualizar seu Conteúdo."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def event_content_params
    params.require(:event_content).permit(:title, :description)
  end

  def set_event_content
    begin
      @event_content = current_user.event_contents.find(params[:id])
    rescue
      redirect_to events_path, notice: "Conteúdo Indisponível!"
    end
  end

  def set_event_content_files
    @files = @event_content.files.select { |file| file.persisted? }
  end
end
