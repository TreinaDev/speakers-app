class CurriculumContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_curriculum
  before_action :set_event_contents, only: %i[ new ]
  def new
    @curriculum_content = @curriculum.curriculum_contents.build
  end

  def create
    @curriculum_content = @curriculum.curriculum_contents.build(set_curriculum_content_params)
    return redirect_to schedule_item_path(@curriculum.schedule_item_code), notice: t('curriculum_contents.create.success') if @curriculum_content.save

    redirect_to events_path, alert: t('curriculum_contents.create.error')
  end

  def show
    @curriculum_content = @curriculum.curriculum_contents.find(params[:id])
  end

  private

  def set_curriculum
    @curriculum = current_user.curriculums.find_by(id: params[:curriculum_id])
    redirect_to events_path, alert: t('curriculum_contents.set_curriculum.error') unless @curriculum
  end

  def set_curriculum_content_params
    params.require(:curriculum_content).permit(:event_content_id)
  end

  def set_event_contents
    @event_contents = current_user.event_contents.select { |content| !@curriculum.event_contents.include?(content) }
  end
end
