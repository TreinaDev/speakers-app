require 'rails_helper'

describe ExternalParticipantApi::GetEventFeedbacksService do
  context '#call' do
    it 'when Api return success' do
      json = [
      {
        id: 1,
        name: 'Bruno',
        title: 'Foi bom',
        description: 'Valeu a pena'
      },
      {
        id: 2,
        name: 'Thiago',
        title: 'Recomendo',
        description: 'Achei bacana'
      },
      {
        id: 3,
        name: 'Pedro',
        title: 'Top',
        description: 'Muito bom'
      }
      ]
      response = instance_double(Faraday::Response, success?: true, body: json.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetEventFeedbacksService.new(event_id: 1, speaker: 'joao@email.com')

      feedbacks = service.call

      expect(feedbacks.count).to eq 3
      expect(feedbacks[0].name).to eq 'Bruno'
      expect(feedbacks[0].title).to eq 'Foi bom'
      expect(feedbacks[0].description).to eq 'Valeu a pena'
      expect(feedbacks[1].name).to eq 'Thiago'
      expect(feedbacks[1].title).to eq 'Recomendo'
      expect(feedbacks[1].description).to eq 'Achei bacana'
      expect(feedbacks[2].name).to eq 'Pedro'
      expect(feedbacks[2].title). to eq 'Top'
      expect(feedbacks[2].description).to eq 'Muito bom'
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