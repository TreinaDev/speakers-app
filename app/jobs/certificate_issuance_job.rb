class CertificateIssuanceJob < ApplicationJob
  queue_as :default

  def perform(schedule_item_code:, schedule_item_name:, date_perfome:, event_name:, date_of_occurrence:, length:, participant_name:, participant_register:, participant_email:)
    participant_enableds = ParticipantRecord.where(schedule_item_code: schedule_item_code, enabled_certificate: true)
    participant_enableds.each do |participant|
      user = User.find(participant.user_id)
      Certificate.create(responsable_name: user.full_name, user: user, speaker_code: user.token, event_name: event_name,
                         schedule_item_name: schedule_item_name, date_of_occurrence: date_of_occurrence, issue_date: date_perfome,
                         length: length, schedule_item_code: schedule_item_code, participant_code: participant.participant_code,
                         participant_name: participant_name, participant_register: participant_register)

      CertificateNotifyMailer.send_certificate(
      participant_code: participant.participant_code,
      participant_name: participant_name,
      participant_email: participant_email,
      schedule_item_code: schedule_item_code
    ).deliver_later
    end
  end
end
