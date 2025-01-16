require 'rails_helper'

describe Event do
    it 'should get all event information' do
      json = File.read(Rails.root.join('spec/support/events_data.json'))
      url = 'localhost:3001/api/events'
      response = double('faraday_response', body: json, status: 200)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      result = Event.all
      expect(result.length).to eq 2
      expect(result[0].name).to eq 'Event1'
      expect(result[0].url).to eq ''
      expect(result[0].description).to eq 'Event1 description'
      expect(result[0].start_date).to eq '14-01-2025'
      expect(result[0].end_date).to eq '16-01-2025'
      expect(result[0].event_type).to eq 'in-person'
      expect(result[0].location).to eq 'Palhoça'
      expect(result[0].participant_limit).to eq 20
      expect(result[0].status).to eq 'published'
      expect(result[1].name).to eq 'Event2'
      expect(result[1].url).to eq ''
      expect(result[1].description).to eq 'Event2 description'
      expect(result[1].start_date).to eq '15-01-2025'
      expect(result[1].end_date).to eq '17-01-2025'
      expect(result[1].event_type).to eq 'in-person'
      expect(result[1].location).to eq 'Florianópolis'
      expect(result[1].participant_limit).to eq 20
      expect(result[1].status).to eq 'draft'
    end

    it 'raise connection failed error' do
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      Event.all

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end

    it 'raise error' do
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise
      Event.all

      expect(logger).to have_received(:error).with("Erro: ")
    end
end
