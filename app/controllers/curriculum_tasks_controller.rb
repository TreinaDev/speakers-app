class CurriculumTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_curriculum

  def new
    @curriculum_task = @curriculum.curriculum_tasks.build
  end

  def create
    @curriculum_task = @curriculum.curriculum_tasks.build(set_curriculum_task_params)
    return redirect_to schedule_item_path(@curriculum.schedule_item_code), notice: 'Tarefa adicionada com sucesso!' if @curriculum_task.save

    flash.now[:alert] = 'Falha ao adicionar tarefa.'
    render :new, status: :unprocessable_entity
  end

  private

  def set_curriculum
    @curriculum = current_user.curriculums.find_by(id: params[:curriculum_id])
    redirect_to events_path, alert: "Conteúdo indisponível!" unless @curriculum
  end

  def set_curriculum_task_params
    params.require(:curriculum_task).permit(:title, :description, :cestificate_requirement)
  end
end
