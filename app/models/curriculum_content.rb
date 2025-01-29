class CurriculumContent < ApplicationRecord
  belongs_to :curriculum
  belongs_to :event_content

  validates_uniqueness_of :curriculum_id, scope: :event_content_id
end
