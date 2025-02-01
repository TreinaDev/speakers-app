class CurriculumTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_curriculum

  def new
    @curriculum_task = @curriculum.curriculum_tasks.build
  end

  def create
    @curriculum_task = @curriculum.curriculum_tasks.build(set_curriculum_task_params)
    return redirect_to schedule_item_path(@curriculum.schedule_item_code), notice: t('curriculum_tasks.create.success') if @curriculum_task.save

    flash.now[:alert] = t('curriculum_tasks.create.error')
    render :new, status: :unprocessable_entity
  end

  def show
    @task = @curriculum.curriculum_tasks.find_by(id: params[:id])
  end

  private

  def set_curriculum
    @curriculum = current_user.curriculums.find_by(id: params[:curriculum_id])
    redirect_to events_path, alert: t('curriculum_tasks.set_curriculum.error') unless @curriculum
  end

  def set_curriculum_task_params
    params.require(:curriculum_task).permit(:title, :description, :certificate_requirement)
  end
end
