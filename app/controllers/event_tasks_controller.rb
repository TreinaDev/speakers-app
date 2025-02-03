class EventTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_event_content_owner, only: :create
  before_action :set_event_task, only: %i[ show edit update ]
  before_action :set_event_contents, only: %i[ new create edit update ]

  def index
    @event_tasks = current_user.event_tasks
  end

  def new
    @event_task = current_user.event_tasks.build
  end

  def create
    @event_task = current_user.event_tasks.build(event_task_params)
    return redirect_to event_tasks_path, notice: t('event_tasks.create.success') if @event_task.save

    flash.now["alert"] = t('event_tasks.create.fail')
    render :new, status: :unprocessable_entity
  end

  def show; end

  def edit; end

  def update
    if @event_task.update(event_task_params)
      redirect_to @event_task, notice: t('event_tasks.update.success')
    else
      flash.now[:alert] = t('event_tasks.update.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def event_task_params
    params.require(:event_task).permit(:name, :description, :certificate_requirement, event_content_ids: [])
  end

  def set_event_task
    begin
      @event_task = current_user.event_tasks.find(params[:id])
    rescue
      redirect_to events_path, alert: t('event_tasks.set_event_task.unauthorized_access')
    end
  end

  def set_event_contents
    @contents = current_user.event_contents
  end

  def check_event_content_owner
    return unless current_user.event_contents.present?
    contents = params[:event_task][:event_content_ids].reject(&:blank?)
    contents.each do |content|
      unless current_user.event_contents.find_by(id: content)
        flash.now["alert"] = t('.event_tasks.check_event_content_owner.content_unavailable')
        redirect_to event_tasks_path
      end
    end
  end
end
