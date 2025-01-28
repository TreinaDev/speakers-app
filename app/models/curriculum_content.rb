class CurriculumContent < ApplicationRecord
  belongs_to :curriculum
  belongs_to :event_content
end
