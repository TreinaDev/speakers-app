class EventContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_content, only: %i[ show edit update ]
  before_action :set_event_content_files, only: %i[ edit update ]
  before_action :set_event_content_breadcrumb

  def index
    @event_contents = current_user.event_contents
  end

  def show
    add_breadcrumb @event_content.title, "#"
  end

  def new
    @event_content = current_user.event_contents.build
    add_breadcrumb t("new_content"), "#"
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

  def edit
    add_breadcrumb "#{t("edit")} #{@event_content.title}", "#"
  end

  def update
    generate_update_history if params[:event_content][:is_update] == '1'
    @event_content.files = params[:event_content][:files]
    if @event_content.update(event_content_params)
      redirect_to @event_content, notice: t('event_contents.update.success')
    else
      flash.now[:alert] = t('event_contents.update.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def remove_file
    @event_content = EventContent.find_by(code: params[:code])
    file = ActiveStorage::Blob.find_signed(params[:id])
    if file.attachments.first.purge
      respond_to do |format|
        format.html do
          flash.now[:notice] = t('events_contents.show.file_removed')
          return redirect_to event_content_path(@event_content)
        end
      end
    end
    redirect_to event_content_path(@event_content), alert: t('events_contents.show.file_remove_failed')
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

  def generate_update_history
    @update_history = @event_content.update_histories.build(user: @event_content.user, creation_date: Date.today,
                                                            description: params[:event_content][:update_description])

    return if @update_history.valid?
    @event_content.errors.add(:base, @update_history.errors.first)
  end

  def set_event_content_breadcrumb
    add_breadcrumb t("my_contents"), event_contents_path
  end
end
