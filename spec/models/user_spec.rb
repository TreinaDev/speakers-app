require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { validate_presence_of(:first_name) }
    it { validate_presence_of(:last_name) }
  end

  context '#api_auth_user' do
    it 'with success' do
      allow_any_instance_of(ExternalEventApi::UserFindEmailService).to receive(:find_email).and_return(true)
      user = User.new(email: 'joao@email.com', first_name: 'João', last_name: 'Almeida', password: '123456')

      expect { user.save }.to change(User, :count).by(1)
    end

    it 'dont find email' do
      allow_any_instance_of(ExternalEventApi::UserFindEmailService).to receive(:find_email).and_return(false)
      user = User.new(email: 'joao@email.com', first_name: 'João', last_name: 'Almeida', password: '123456')

      expect { user.save }.to change(User, :count).by(0)
    end
  end
end
