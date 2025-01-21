class EventTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_event_content_owner, only: :create

  def index
    @event_tasks = current_user.event_tasks
  end

  def new
    @event_task = current_user.event_tasks.build
    @contents = current_user.event_contents
  end

  def create
    @event_task = current_user.event_tasks.build(event_task_params)
    @contents = current_user.event_contents
    return redirect_to event_tasks_path, notice: "Tarefa cadastrada com sucesso!" if @event_task.save

    flash.now["alert"] = "Falha ao criar tarefa."
    render :new, status: :unprocessable_entity
  end

  private

  def event_task_params
    params.require(:event_task).permit(:name, :description, :certificate_requirement, event_content_ids: [])
  end

  def check_event_content_owner
    return unless current_user.event_contents.present?
    contents = params[:event_task][:event_content_ids].reject(&:blank?)
    contents.each do |content|
      unless current_user.event_contents.find_by(id: content)
        flash.now["alert"] = "Conteúdo indisponível"
        redirect_to event_tasks_path
      end
    end
  end
end
