require 'rails_helper'

describe ExternalParticipantApi::GetEventFeedbacksService do
  context '#call' do
    it 'when Api return success' do
      json = {
        "event_id": "LF6IOIUU",
        "feedbacks": [
          {
            "id": 1,
            "title": "Foi bom",
            "comment": "Valeu a pena",
            "mark": 1,
            "user": "Bruno"
          },
          {
            "id": 2,
            "title": "Recomendo",
            "comment": "Achei bacana",
            "mark": 5,
            "user": "Leandro"
          }
        ]
      }
      response = instance_double(Faraday::Response, success?: true, body: json.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetEventFeedbacksService.new(event_id: 1, speaker: 'joao@email.com')

      feedbacks = service.call

      expect(feedbacks.count).to eq 2
      expect(feedbacks[0].attributes.values).to eq [ 1, "Foi bom", "Valeu a pena", 1, "Bruno" ]
      expect(feedbacks[1].attributes.values).to eq [ 2, "Recomendo", "Achei bacana", 5, "Leandro" ]
    end

    it 'when Api return not found' do
      response = instance_double(Faraday::Response, success?: true, body: {})
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetEventFeedbacksService.new(event_id: 1, speaker: 'joao@email.com')

      feedbacks = service.call

      expect(feedbacks.count).to eq 0
    end

    it 'when Connection Failed exception happens' do
      logger = Rails.logger
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      allow(logger).to receive(:error)
      service = ExternalParticipantApi::GetEventFeedbacksService.new(event_id: 1, speaker: 'joao@email.com')

      feedbacks = service.call

      expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
    end
  end
end
