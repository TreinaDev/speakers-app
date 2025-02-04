class Curriculum < ApplicationRecord
  belongs_to :user
  has_many :curriculum_contents
  has_many :event_contents, through: :curriculum_contents
  has_many :curriculum_tasks
  validates :code, presence: true
  validates :code, uniqueness: true


  after_initialize :generate_code, if: :new_record?

  def to_param
    code
  end

  protected

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless Curriculum.where(code: code).exists?
    end
  end
end
