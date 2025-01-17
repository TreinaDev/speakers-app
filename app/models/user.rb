class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, :last_name, presence: true
  before_create :api_auth_user
  has_many :event_contents

  private

  def api_auth_user
    unless ExternalEventApi::UserFindEmailService.new(self.email).find_email
      errors.add(:base, "Algo deu errado, contate o responsável.")
      throw(:abort)
    end
  end
end
