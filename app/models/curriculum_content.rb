class CurriculumContent < ApplicationRecord
  belongs_to :curriculum
  belongs_to :event_content
  has_many :curriculum_task_contents
  has_many :curriculum_tasks, through: :curriculum_task_contents
  validates_uniqueness_of :curriculum_id, scope: :event_content_id
  validate :must_be_event_content_owner

  def title
    event_content.title
  end

  protected

  def must_be_event_content_owner
    return if event_content&.user == curriculum&.user
    errors.add(:base, I18n.t("activerecord.errors.messages.must_be_event_content_owner"))
    throw(:abort)
  end
end
