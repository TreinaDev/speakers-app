class EventTasksController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def new
    @event_task = EventTask.new
    @contents = current_user.event_contents
  end

  def create
    @event_task = current_user.event_tasks.build(event_task_params)
    return redirect_to event_tasks_path, notice: "Tarefa cadastrada com sucesso!" if @event_task.save
    
    @contents = current_user.event_contents
    flash.now["alert"] = "Falha ao criar tarefa."
    render :new, status: :unprocessable_entity
  end

  private

  def event_task_params
    params.require(:event_task).permit(:name, :description, :certificate_requirement, event_content_ids: [])
  end
end
