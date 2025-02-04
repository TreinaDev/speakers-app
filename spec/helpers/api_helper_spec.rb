require 'rails_helper'

describe ApiHelper::ParticipantClient, type: :helper do
  context '.get_participant_event_list' do
    it 'must perform a get request for participant api' do
      event_code = 'ABCS1234'
      response = instance_double(Faraday::Response)
      allow(described_class).to receive(:get_participant_event_list).with(event_code).and_return(response)
      expect(described_class.get_participant_event_list(event_code)).to eq response
    end
  end
end

describe ApiHelper::EventClient, type: :helper do
  context '.get_schedule_items' do
    it 'must perform a get request for schedules in event api' do
      speaker = create(:user)
      event_code = 'ABCS1234'
      response = instance_double(Faraday::Response)
      expected_url = "http://localhost:3001/api/v1/speakers/#{speaker.token}/schedules/#{event_code}"
      allow(Faraday).to receive(:get).with(expected_url).and_return(response)

      result = described_class.get_schedule_items(event_code: event_code, token: speaker.token)

      expect(Faraday).to have_received(:get).with(expected_url)
      expect(result).to eq(response)
    end
  end
end
