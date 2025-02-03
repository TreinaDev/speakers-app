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
