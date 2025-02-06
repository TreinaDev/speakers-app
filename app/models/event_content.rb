class EventContent < ApplicationRecord
  belongs_to :user
  has_many :curriculum_contents
  has_many :curriculums, through: :curriculum_contents
  has_many :update_histories
  has_many_attached :files
  has_rich_text :description
  validate :must_have_less_than_five_files
  validate :valid_file_size
  validates :title, :code, presence: true
  validates :code, uniqueness: true
  validate :check_external_video_url


  after_initialize :generate_code, if: :new_record?

  def to_param
    code
  end

  protected

  def must_have_less_than_five_files
    return if self.files.count <= 5
    errors.add(:base, I18n.t("activerecord.errors.messages.must_have_less_than_five_files"))
    throw(:abort)
  end

  def valid_file_size
    return unless files.attached?

    files.each do |file|
      unless file.blob.byte_size <= 50.megabyte
        errors.add(:base, I18n.t("activerecord.errors.messages.valid_file_size"))
      end
    end
  end

  def check_external_video_url
    if external_video_url.present?
      unless external_video_url.include?('youtube.com') || external_video_url.include?('vimeo.com')
        errors.add(:external_video_url, 'é inválida.')
      end
    end
  end

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless CurriculumTask.where(code: code).exists?
    end
  end
end
