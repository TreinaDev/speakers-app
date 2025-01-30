class CurriculumContent < ApplicationRecord
  belongs_to :curriculum
  belongs_to :event_content

  validates_uniqueness_of :curriculum_id, scope: :event_content_id
  validate :must_be_event_content_owner

  protected

  def must_be_event_content_owner
    return if event_content&.user == curriculum&.user
    errors.add(:base, "Conteúdo indisponível")
    throw(:abort)
  end
end
