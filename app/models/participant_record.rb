class ParticipantRecord < ApplicationRecord
  belongs_to :user
  has_many :participant_tasks

  validates :schedule_item_code, :participant_code, presence: true

  def change_enabled_certificate(curriculum, new_task)
    if new_task.curriculum_task.mandatory?
      curriculum_mandatory_task_codes = curriculum.curriculum_tasks.mandatory.map { |task| task.code }

      participant_mandatory_task_codes = participant_tasks.map { |task| task.curriculum_task.code if task.curriculum_task.mandatory? }.compact
      participant_mandatory_task_codes << new_task.curriculum_task.code
      update(enabled_certificate: true) if curriculum_mandatory_task_codes.length == participant_mandatory_task_codes.length &&
                                        curriculum_mandatory_task_codes.all? { |task| participant_mandatory_task_codes.include?(task) }
    end
  end
end
