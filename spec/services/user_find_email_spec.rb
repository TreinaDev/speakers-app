require 'rails_helper'

describe ExternalEventApi::UserFindEmailService do
  context '#find_email' do
    it 'when API return success' do
      email = 'test@email.com'
      response = instance_double(Faraday::Response, success?: true)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalEventApi::UserFindEmailService.find_email(email)

      expect(service).to eq(true)
    end

    it 'when API return not found' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email)
      response = instance_double(Faraday::Response, success?: false)
      allow(Faraday).to receive(:get).and_return(response)

      expect(service.find_email).to eq(false)
    end

    it 'when Connection Failed exception happens' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

      expect(Rails.logger).to receive(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(service.find_email).to eq(false)
    end
  end
end
