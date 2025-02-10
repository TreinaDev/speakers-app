require 'rails_helper'

describe ExternalParticipantApi::GetScheduleItemFeedbacksService do
  context '#call' do
    it 'when Api return success' do
      json = {
        "item_feedbacks": [
          {
            "id": 4,
            "title": "Faltou slides",
            "comment": "Não entendi o final",
            "mark": 2,
            "user": "Master Teste",
            "schedule_item_id": "TP1LEMD3"
          },
          {
            "id": 5,
            "title": "Boa didática",
            "comment": "Gostei do conteúdo",
            "mark": 1,
            "user": "Master Teste",
            "schedule_item_id": "TP1LEMD3"
          }
        ]
      }
      response = instance_double(Faraday::Response, success?: true, body: json.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetScheduleItemFeedbacksService.new(schedule_item_id: 1)

      feedbacks = service.call

      expect(feedbacks.count).to eq 2
      expect(feedbacks[0].attributes.values).to eq [ 4, "Faltou slides", "Não entendi o final",  2, "Master Teste", "TP1LEMD3" ]
      expect(feedbacks[1].attributes.values).to eq [ 5, "Boa didática", "Gostei do conteúdo", 1, "Master Teste", "TP1LEMD3" ]
    end

    it 'when Api return not found' do
      response = instance_double(Faraday::Response, success?: true, body: {})
      allow(Faraday).to receive(:get).and_return(response)
      service = ExternalParticipantApi::GetScheduleItemFeedbacksService.new(schedule_item_id: 1)

      schedule_item_feedbacks = service.call

      expect(schedule_item_feedbacks.count).to eq 0
    end

    it 'when Connection Failed exception happens' do
      logger = Rails.logger
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      allow(logger).to receive(:error)
      service = ExternalParticipantApi::GetScheduleItemFeedbacksService.new(schedule_item_id: 1)

      service.call

      expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
    end
  end
end
