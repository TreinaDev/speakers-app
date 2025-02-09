class Api::V1::CertificatesController < Api::V1::ApiController
  def show
    @participant_record = ParticipantRecord.find_by(
      participant_code: params[:participant_code],
      schedule_item_code: params[:curriculum_schedule_item_code]
    )

    return render status: :not_found, json: { error: I18n.t('not_found_error', model: Certificate.model_name.human) } if @participant_record.nil?

    speaker = User.find(@participant_record.user_id)
    schedule_item = ScheduleItem.find(schedule_item_code: params[:curriculum_schedule_item_code], token: speaker.token)
    event = Event.find(token: speaker.token, code: schedule_item.event_code)
    participant = Participant.find(participant_code: params[:participant_code])
    participant_name = Participant.full_name(participant.name, participant.last_name)

    @certificate = Certificate.find_or_create_by(participant_code: params[:participant_code], schedule_item_code: params[:curriculum_schedule_item_code]) do |certificate|
      certificate.responsable_name = speaker.full_name
      certificate.speaker_code = speaker.token
      certificate.schedule_item_name = schedule_item.name
      certificate.event_name = event.name
      certificate.date_of_occurrence = schedule_item.date
      certificate.issue_date = Date.current
      certificate.length = Certificate.time_diff(schedule_item)
      certificate.token = SecureRandom.alphanumeric(8).upcase
      certificate.user_id = speaker.id
      certificate.participant_name = participant_name
      certificate.participant_register = participant.cpf
    end
  end
end
