class CurriculumContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_curriculum
  before_action :set_event_contents, only: %i[ new ]
  before_action :set_curriculum_content_breadcrumb, only: %i[ show ]

  def new
    @curriculum_content = @curriculum.curriculum_contents.build
  end

  def create
    @curriculum_content = @curriculum.curriculum_contents.build(set_curriculum_content_params)
    return redirect_to schedule_item_path(@curriculum.schedule_item_code), notice: t('curriculum_contents.create.success') if @curriculum_content.save
    redirect_to events_path, alert:  t('curriculum_contents.create.fail')
  end

  def show
    @curriculum_content = @curriculum.curriculum_contents.find_by(code: params[:code])
    redirect_to schedule_item_path(@curriculum.schedule_item_code), alert: t('curriculum_contents.set_curriculum.content_unavailable') if @curriculum_content.nil?
    add_breadcrumb @curriculum_content&.title, "#"
  end

  private

  def set_curriculum
    @curriculum = current_user.curriculums.find_by(code: params[:curriculum_code])
    redirect_to events_path, alert: t('curriculum_contents.set_curriculum.content_unavailable') unless @curriculum
  end

  def set_curriculum_content_params
    params.require(:curriculum_content).permit(:event_content_id)
  end

  def set_event_contents
    @event_contents = current_user.event_contents.select { |content| !@curriculum.event_contents.include?(content) }
  end

  def set_curriculum_content_breadcrumb
    @schedule_item = ScheduleItem.find(schedule_item_code: @curriculum&.schedule_item_code, token: current_user&.token)
    @event = Event.find(code: @schedule_item&.event_code, token: current_user&.token)
    add_breadcrumb @event.name, event_path(@schedule_item.event_code) if @event
    add_breadcrumb @schedule_item.name, schedule_item_path(@schedule_item.code) if @schedule_item
  end
end
