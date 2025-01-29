require 'rails_helper'

describe ExternalEventApi::UserFindEmailService do
  context '#call' do
    it 'when API return success' do
      email = 'test@email.com'
      token = {
        "token": "ABCD1234"
      }
      response = instance_double(Faraday::Response, success?: true, body: token.to_json )
      allow(Faraday).to receive(:post).and_return(response)
      service = ExternalEventApi::UserFindEmailService.call(email: email)

      expect(service).to eq('ABCD1234')
    end

    it 'when API return not found' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email: email)
      response = instance_double(Faraday::Response, success?: false)
      allow(Faraday).to receive(:post).and_return(response)

      expect(service.call).to be_nil
    end

    it 'when Connection Failed exception happens' do
      email = 'test@email.com'
      logger = Rails.logger
      allow(logger).to receive(:error)
      service = ExternalEventApi::UserFindEmailService.new(email: email)
      allow(Faraday).to receive(:post).and_raise(Faraday::ConnectionFailed)
      token = service.call

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(token).to be_nil
    end
  end
end
