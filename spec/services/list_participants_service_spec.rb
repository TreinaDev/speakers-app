require 'rails_helper'

describe ExternalParticipantApi::ListParticipantsService do
  context '#call' do
    it 'when Api return success' do
      json = [
        {
          id: 1,
          name: 'Bruno'
        },
        {
          id: 2,
          name: 'Thiago'
        },
        {
          id: 3,
          name: 'Pedro'
        }
      ]
      response = instance_double(Faraday::Response, success?: true, body: json.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::ListParticipantsService.new(1)

      participants = service.call

      expect(participants.count).to eq 3
      expect(participants[0].name).to eq 'Bruno'
      expect(participants[1].name).to eq 'Thiago'
      expect(participants[2].name).to eq 'Pedro'
    end

    it 'when Api return not found' do
      response = instance_double(Faraday::Response, success?: true, body: {})
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::ListParticipantsService.new(1)

      participants = service.call

      expect(participants.count).to eq 0
    end

    it 'when Connection Failed exception happens' do
      logger = Rails.logger
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      allow(logger).to receive(:error)
      service = ExternalParticipantApi::ListParticipantsService.new(1)

      participants = service.call

      expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
    end
  end
end