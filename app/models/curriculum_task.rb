class CurriculumTask < ApplicationRecord
  belongs_to :curriculum
  enum :certificate_requirement, { mandatory: 1, optional: 0 }, default: :optional
  has_many :curriculum_task_contents
  has_many :curriculum_contents, through: :curriculum_task_contents
  validates :title, :description, :certificate_requirement, presence: true
  validates_uniqueness_of :title, scope: :curriculum_id
end
