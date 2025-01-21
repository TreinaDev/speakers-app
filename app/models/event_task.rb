class EventTask < ApplicationRecord
  belongs_to :user
  has_many :event_task_contents
  has_many :event_contents, through: :event_task_contents
  accepts_nested_attributes_for :event_task_contents, allow_destroy: true

  validates :name, :description, :certificate_requirement, presence: true

  enum :certificate_requirement, { mandatory: 1, optional: 0 }, default: :optional
end
