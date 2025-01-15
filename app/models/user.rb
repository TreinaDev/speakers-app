class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :api_auth_user

  private

  def api_auth_user
    unless ExternalEventApi::UserFindEmailService.new(self.email).find_email
      errors.add(:base, 'Algo deu errado, contate o responsável')
      throw(:abort)
    end
  end
end
