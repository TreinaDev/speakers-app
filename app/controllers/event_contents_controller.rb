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
      redirect_to @event_content, notice: t('event_contents.create.success')
    else
      flash.now[:alert] = t('event_contents.create.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @event_content.files = params[:event_content][:files]
    if @event_content.update(event_content_params)
      redirect_to @event_content, notice: t('event_contents.update.success')
    else
      flash.now[:alert] = t('event_contents.update.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def event_content_params
    params.require(:event_content).permit(:title, :description, :external_video_url)
  end

  def set_event_content
      @event_content = current_user.event_contents.find_by(code: params[:code])
      redirect_to events_path, alert: t('event_contents.set_event_content.content_unavailable') if @event_content.nil?
  end

  def set_event_content_files
    @files = @event_content.files.select { |file| file.persisted? }
  end
end
