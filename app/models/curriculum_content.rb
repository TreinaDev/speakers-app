class CurriculumContent < ApplicationRecord
  belongs_to :curriculum
  belongs_to :event_content
  has_many :curriculum_task_contents
  has_many :curriculum_tasks, through: :curriculum_task_contents
  validates_uniqueness_of :curriculum_id, scope: :event_content_id
  validate :must_be_event_content_owner
  validates :code, presence: true

  after_initialize :generate_code, if: :new_record?

  def title
    event_content.title
  end

  def to_param
    code
  end
  
  protected

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless CurriculumContent.where(code: code).exists?
    end
  end

  def must_be_event_content_owner
    return if event_content&.user == curriculum&.user
    errors.add(:base, I18n.t("activerecord.errors.messages.must_be_event_content_owner"))
    throw(:abort)
  end
end
