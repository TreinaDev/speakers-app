class Certificate < ApplicationRecord
  belongs_to :user
  before_create :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.alphanumeric(20)
      break unless Certificate.exists?(token: self.token)
    end
  end
end
