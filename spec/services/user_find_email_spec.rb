require 'rails_helper'

RSpec.describe ExternalEventApi::UserFindEmailService do
  describe '#find_email' do
    context 'quando a API retorna sucesso' do
      it 'retorna true' do
        email = 'test@email.com'
        service = ExternalEventApi::UserFindEmailService.new(email)
        response = instance_double(Faraday::Response, success?: true)
        allow(Faraday).to receive(:get).and_return(response)

        expect(service.find_email).to eq(true)
      end
    end

    context 'quando a API retorna falha' do
      it 'retorna false' do
        email = 'test@email.com'
        service = ExternalEventApi::UserFindEmailService.new(email)
        response = instance_double(Faraday::Response, success?: false)
        allow(Faraday).to receive(:get).and_return(response)

        expect(service.find_email).to eq(false)
      end
    end

    context 'quando ocorre uma exceção' do
      it 'loga o erro e retorna false' do
        email = 'test@email.com'
        service = ExternalEventApi::UserFindEmailService.new(email)
        allow(Faraday).to receive(:get).and_raise(StandardError.new('Erro de conexão'))

        expect(Rails.logger).to receive(:error).with(instance_of(StandardError))
        expect(service.find_email).to eq(false)
      end
    end
  end
end
