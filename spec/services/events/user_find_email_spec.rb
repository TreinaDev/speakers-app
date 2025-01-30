require 'rails_helper'

describe ExternalEventApi::UserFindEmailService do
  context '#call' do
    it 'when API return success' do
      email = 'test@email.com'
      token = { "token" => "ABCD1234" }
      response = instance_double(Faraday::Response, success?: true, body: token.to_json)
      connection = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:post).and_return(response)

      service = ExternalEventApi::UserFindEmailService.new(email: email)

      expect(service.call).to eq(token)
    end

    it 'when API return not found' do
      email = 'test@email.com'
      error = { error: "Palestrante não encontrado." }
      response = instance_double(Faraday::Response, success?: false, body: error.to_json)
      connection = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:post).and_return(response)

      service = ExternalEventApi::UserFindEmailService.new(email: email)
      error = { "error"=> "Palestrante não encontrado." }

      expect(service.call).to eq error
    end

    it 'when Connection Failed exception happens' do
      email = 'test@email.com'
      logger = Rails.logger
      allow(logger).to receive(:error)
      connection = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:post).and_raise(Faraday::ConnectionFailed)

      service = ExternalEventApi::UserFindEmailService.new(email: email)
      token = service.call

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(token).to be_nil
    end
  end
end
