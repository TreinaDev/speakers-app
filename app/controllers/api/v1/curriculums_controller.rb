class Api::V1::CurriculumsController < Api::V1::ApiController
  helper ApplicationHelper
  def show
    @curriculum = Curriculum.find_by(schedule_item_code: params[:curriculum_schedule_item_code])
    return render status: :not_found, json: { error: I18n.t('not_found_error', model: Curriculum.model_name.human) } if @curriculum.nil?

    participant_record = ParticipantRecord.find_by(participant_code: params[:participant_code], schedule_item_code: params[:curriculum_schedule_item_code])
    @participant_tasks = participant_record.participant_tasks.map { |task| task.curriculum_task_id } if participant_record
    schedule_item = ScheduleItem.find(schedule_item_code: params[:curriculum_schedule_item_code], token: @curriculum.user.token)
    @tasks_available = Time.current >= schedule_item.event_start_date

    @certificate = Certificate.find_by(participant_code: params[:participant_code], schedule_item_code: params[:curriculum_schedule_item_code]) if participant_record && participant_record.enabled_certificate
  end
end
