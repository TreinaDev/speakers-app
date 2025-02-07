class ParticipantRecord < ApplicationRecord
  belongs_to :user
  has_many :participant_tasks

  validates :schedule_item_code, :participant_code, presence: true
end
