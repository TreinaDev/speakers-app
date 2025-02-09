require 'rails_helper'

describe ExternalParticipantApi::GetParticipantDetailsService do
  context '#call' do
    it 'when Api return success' do
      json = {
        "email": "joao@email.com",
        "name": "João",
        "last_name": "Campus",
        "cpf": "111.111.111-11",
        "code": "ABC123"
      }
      response = instance_double(Faraday::Response, success?: true, body: json.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetParticipantDetailsService.new(participant_code: 'ABC123')

      participant = service.call

      expect(participant.email).to eq 'joao@email.com'
      expect(participant.name).to eq 'João'
      expect(participant.last_name).to eq 'Campus'
      expect(participant.cpf).to eq '111.111.111-11'
      expect(participant.code).to eq 'ABC123'
    end

    it 'when Api return not found' do
      response = instance_double(Faraday::Response, success?: true, body: {})
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetParticipantDetailsService.new(participant_code: 'ABC123')

      participant = service.call

      expect(participant).to be_nil
    end

    it 'when Connection Failed exception happens' do
      logger = Rails.logger
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      allow(logger).to receive(:error)
      service = ExternalParticipantApi::GetParticipantDetailsService.new(participant_code: 'ABC123')

      participant = service.call

      expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
    end
  end
end
