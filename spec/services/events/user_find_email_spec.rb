require 'rails_helper'

describe ExternalEventApi::UserFindEmailService do
  context '#call' do
    it 'when API return success' do
      email = 'test@email.com'
      response = instance_double(Faraday::Response, success?: true)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalEventApi::UserFindEmailService.call(email: email)

      expect(service).to eq(true)
    end

    it 'when API return not found' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email: email)
      response = instance_double(Faraday::Response, success?: false)
      allow(Faraday).to receive(:get).and_return(response)

      expect(service.call).to eq(false)
    end

    it 'when Connection Failed exception happens' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email: email)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

      expect(Rails.logger).to receive(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(service.call).to eq(false)
    end
  end
end
