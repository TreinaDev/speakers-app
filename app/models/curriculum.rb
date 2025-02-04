class Curriculum < ApplicationRecord
  belongs_to :user
  has_many :curriculum_contents
  has_many :event_contents, through: :curriculum_contents
  has_many :curriculum_tasks

  validates :code, presence: true

  after_initialize :generate_code, if: :new_record?

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless Curriculum.where(code: code).exists?
    end
  end

  # Necessário para sobreescrever o metodo to_param, ao chamar o objeto Curriculum irá retornar o código em vez do id
  # Ex: example_path(@curriculum) o rails vai interpretar @curriculum como curriculum.code ao invés do padrão que é o curriculum.id
  def to_param
    code
  end
end
