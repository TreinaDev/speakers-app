require 'rails_helper'

describe ExternalParticipantApi::ListParticipantsService do
  context '#call' do
    it 'when Api return success' do
      json = {
        "id": "G69W9URQ5",
        "sold_tickets": 2,
        "participants": [
          {
            "name": "Clorisberto",
            "last_name": "Teste",
            "email": "master@email.com",
            "cpf": "48563548506"
          },
          {
            "name": "Josébeltrano",
            "last_name": "Silva",
            "email": "cristiano@email.com",
            "cpf": "60273054791"
          }
        ]
      }

      response = instance_double(Faraday::Response, success?: true, body: json.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::ListParticipantsService.new(schedule_item_code: 1)

      participants = service.call

      expect(participants.count).to eq 2
      expect(participants[0].name).to eq 'Clorisberto'
      expect(participants[1].name).to eq 'Josébeltrano'
    end

    it 'when Api return not found' do
      response = instance_double(Faraday::Response, success?: true, body: {})
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::ListParticipantsService.new(schedule_item_code: 1)

      participants = service.call

      expect(participants.count).to eq 0
    end

    it 'when Connection Failed exception happens' do
      logger = Rails.logger
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      allow(logger).to receive(:error)
      service = ExternalParticipantApi::ListParticipantsService.new(schedule_item_code: 1)

      participants = service.call

      expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
    end
  end
end
