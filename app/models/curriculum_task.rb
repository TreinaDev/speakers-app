class CurriculumTask < ApplicationRecord
  belongs_to :curriculum
  enum :certificate_requirement, { mandatory: 1, optional: 0 }, default: :optional
  has_many :curriculum_task_contents
  has_many :curriculum_contents, through: :curriculum_task_contents
  validates :title, :description, :certificate_requirement, :code, presence: true
  validates :code, uniqueness: true
  validates_uniqueness_of :title, scope: :curriculum_id


  def translated_certificate_requirement(symbol)
    I18n.t("activerecord.attributes.curriculum_task.certificate_requirements.#{symbol}")
  end
  after_initialize :generate_code, if: :new_record?

  def to_param
    code
  end

  protected

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless CurriculumTask.where(code: code).exists?
    end
  end
end
