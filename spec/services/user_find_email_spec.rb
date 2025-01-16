require 'rails_helper'

describe ExternalEventApi::UserFindEmailService do
  context '#find_email' do
    it 'quando a Api retorna sucesso' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email)
      response = instance_double(Faraday::Response, success?: true)
      allow(Faraday).to receive(:get).and_return(response)

      expect(service.find_email).to eq(true)
    end

    it 'quando a Api retorna não localizado' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email)
      response = instance_double(Faraday::Response, success?: false)
      allow(Faraday).to receive(:get).and_return(response)

      expect(service.find_email).to eq(false)
    end

    it 'quando ocorre uma excessão loga o erro e retorna false' do
      email = 'test@email.com'
      service = ExternalEventApi::UserFindEmailService.new(email)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

      expect(Rails.logger).to receive(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(service.find_email).to eq(false)
    end
  end
end
