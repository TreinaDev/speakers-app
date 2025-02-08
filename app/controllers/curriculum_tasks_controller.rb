class CurriculumTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_curriculum
  before_action :check_curriculum_content_owner, only: %i[ create ]
  before_action :set_curriculum_task_breadcrumb, only: %i[ show ]
  def new
    @curriculum_contents = @curriculum.curriculum_contents
    @curriculum_task = @curriculum.curriculum_tasks.build
  end

  def create
    @curriculum_task = @curriculum.curriculum_tasks.build(set_curriculum_task_params)
    return redirect_to schedule_item_path(@curriculum.schedule_item_code), notice: t('curriculum_tasks.create.success') if @curriculum_task.save
    @curriculum_contents = @curriculum.curriculum_contents
    flash.now[:alert] = t('curriculum_tasks.create.error')
    render :new, status: :unprocessable_entity
  end

  def show
    @task = @curriculum.curriculum_tasks.find_by(code: params[:code])
    redirect_to schedule_item_path(@curriculum.schedule_item_code), alert: t('curriculum_tasks.set_curriculum.error') if @task.nil?
    add_breadcrumb @task&.title, "#"
  end

  private

  def set_curriculum
    @curriculum = current_user.curriculums.find_by(code: params[:curriculum_code])
    redirect_to events_path, alert: t('curriculum_tasks.set_curriculum.error') unless @curriculum
  end

  def set_curriculum_task_params
    params.require(:curriculum_task).permit(:title, :description, :certificate_requirement, curriculum_content_ids: [])
  end

  def check_curriculum_content_owner
    return if params[:curriculum_task][:curriculum_content_ids].blank?
    contents = params[:curriculum_task][:curriculum_content_ids].reject(&:blank?)
    contents.each do |content|
      unless @curriculum.curriculum_contents.find_by(id: content)
        flash.now["alert"] = "Conteúdo indisponível"
        redirect_to schedule_item_path(@curriculum.schedule_item_code)
      end
    end
  end

  def set_curriculum_task_breadcrumb
    @schedule_item = ScheduleItem.find(schedule_item_code: @curriculum.schedule_item_code, token: current_user.token)
    @event = Event.find(code: @schedule_item&.event_code, token: current_user.token)
    add_breadcrumb @event.name, event_path(@schedule_item.event_code) if @event
    add_breadcrumb @schedule_item.name, schedule_item_path(@schedule_item.code) if @schedule_item
  end
end
