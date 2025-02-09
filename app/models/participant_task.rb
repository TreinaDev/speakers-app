class ParticipantTask < ApplicationRecord
  belongs_to :participant_record
  belongs_to :curriculum_task

  before_create :validate_enabled_certificate

  private

  def validate_enabled_certificate
    if participant_record.present? && curriculum_task.present?
      participant_record.change_enabled_certificate(curriculum_task.curriculum, self)
    end
  end
end
