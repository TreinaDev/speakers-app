class EventContent < ApplicationRecord
  belongs_to :user
  has_many_attached :files
  validate :must_have_less_than_five_files
  validate :valid_file_size
  validates :title, presence: true
  has_rich_text :description

  protected

  def must_have_less_than_five_files
    return if self.files.count <= 5
    errors.add(:base, "Não é possível enviar mais que 5 arquivos.")
    throw(:abort)
  end

  def valid_file_size
    return unless files.attached?

    files.each do |file|
      unless file.blob.byte_size <= 50.megabyte
        errors.add(:base, "Não é possível enviar arquivos com mais de 50mb.")
      end
    end
  end
end
