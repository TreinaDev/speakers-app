class Api::V1::ParticipantTasksController < Api::V1::ApiController
  def create
    task = CurriculumTask.find_by(code: params[:task_code])
    return render status: :not_found, json: { error: 'Tarefa não encontrada.' } if task.nil?
    return render status: :not_found, json: { error: 'Código do participante não pode ser em branco.' } if params[:participant_code].blank?

    participant_record = ParticipantRecord.find_or_create_by(participant_code: params[:participant_code]) do |participant|
      participant.user_id = task.curriculum.user.id
      participant.schedule_item_code = task.curriculum.schedule_item_code
    end

    participant_record.participant_tasks.create(curriculum_task: task, task_status: true)
    render status: :ok, json: { message: 'OK' }
  end
end
