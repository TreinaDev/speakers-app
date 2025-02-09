class ParticipantRecord < ApplicationRecord
  belongs_to :user
  has_many :participant_tasks

  validates :schedule_item_code, :participant_code, presence: true
  after_create :scheduling_for_certificate_creation

  def change_enabled_certificate(curriculum, new_task)
    if new_task.present? && new_task.curriculum_task.mandatory? && curriculum.present?
      curriculum_mandatory_task_codes = curriculum.curriculum_tasks.mandatory.map { |task| task.code }

      participant_mandatory_task_codes = participant_tasks.map { |task| task.curriculum_task.code if task.curriculum_task.mandatory? }.compact
      participant_mandatory_task_codes << new_task.curriculum_task.code
      update(enabled_certificate: true) if curriculum_mandatory_task_codes.length == participant_mandatory_task_codes.length &&
                                        curriculum_mandatory_task_codes.all? { |task| participant_mandatory_task_codes.include?(task) }
    end
  end

  private

  def scheduling_for_certificate_creation
    user = User.find(self.user.id)
    schedule_item = ScheduleItem.find(schedule_item_code: self.schedule_item_code, token: user.token)
    length = Certificate.time_diff(schedule_item)
    event = Event.find(code: schedule_item.event_code, token: user.token)
    participant = Participant.find(participant_code: participant_code)
    participant_name = Participant.full_name(participant.name, participant.last_name)
    CertificateIssuanceJob.set(wait_until: event.end_date).perform_later(
      schedule_item_code: schedule_item.code, schedule_item_name: schedule_item.name,
      date_perfome: event.end_date, event_name: event.name, date_of_occurrence: schedule_item.date,
      length: length, participant_name: participant_name, participant_register: participant.cpf,
      participant_email: participant.email
    )
  end
end
