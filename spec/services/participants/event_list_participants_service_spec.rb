require 'rails_helper'

describe ExternalParticipantApi::EventListParticipantsService do
  context '#call' do
  it 'when Api return success' do
    json = {
      "id": "TEQUR4L7",
      "sold_tickets": 3,
      "participants": [
        {
          "name": "Bruno",
          "last_name": "Herculano",
          "email": "herculano@gmail.com",
          "cpf": "11111111111"
        },
        {
          "name": "Thiago",
          "last_name": "Gois",
          "email": "thiago@gmail.com",
          "cpf": "22222222222"
        },
        {
          "name": "Pedro",
          "last_name": "Dias",
          "email": "pedro@gmail.com",
          "cpf": "33333333333"
        }
      ]
    }
    response = instance_double(Faraday::Response, success?: true, body: json.to_json)
    allow(Faraday).to receive(:get).and_return(response)
    service = ExternalParticipantApi::EventListParticipantsService.new(event_code: 1)

    participants = service.call

    expect(participants.count).to eq 3
    expect(participants[0].name).to eq 'Bruno'
    expect(participants[1].name).to eq 'Thiago'
    expect(participants[2].name).to eq 'Pedro'
  end

  it 'when Api return not found' do
    response = instance_double(Faraday::Response, success?: true, body: {})
    allow(Faraday).to receive(:get).and_return(response)
    service = ExternalParticipantApi::EventListParticipantsService.new(event_id: 1)

    participants = service.call

    expect(participants.count).to eq 0
  end

  it 'when Connection Failed exception happens' do
    logger = Rails.logger
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
    allow(logger).to receive(:error)
    service = ExternalParticipantApi::EventListParticipantsService.new(event_id: 1)

    participants = service.call

    expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
  end
  end
end
