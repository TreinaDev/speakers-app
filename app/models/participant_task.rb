class ParticipantTask < ApplicationRecord
  belongs_to :participant_record
  belongs_to :curriculum_task
end
