class EventContent < ApplicationRecord
  belongs_to :user
  has_many :event_task_contents
  has_many :event_tasks, through: :event_task_contents
  has_many :curriculum_contents
  has_many :curriculums, through: :curriculum_contents
  has_many_attached :files
  validate :must_have_less_than_five_files
  validate :valid_file_size
  validates :title, presence: true
  has_rich_text :description

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
end
