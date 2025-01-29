require 'rails_helper'

describe ExternalEventApi::GetAllEventsService do
  context '#call' do
    it 'when api return success' do
      json_response = [
        {
          "id": 1,
          "name": "Event1",
          "url": "",
          "description": "Event1 description",
          "start_date": "14-01-2025",
          "end_date": "16-01-2025",
          "event_type": "in-person",
          "location": "Palhoça",
          "participant_limit": 20,
          "status": "published"
        },
        {
          "id": 2,
          "name": "Event2",
          "url": "",
          "description": "Event2 description",
          "start_date": "15-01-2025",
          "end_date": "17-01-2025",
          "event_type": "in-person",
          "location": "Florianópolis",
          "participant_limit": 20,
          "status": "draft"
        }
      ]
      service = ExternalEventApi::GetAllEventsService.new(email: 'test@email.com')
      response = instance_double(Faraday::Response, success?: true, body: json_response.to_json)
      allow(Faraday).to receive(:get).and_return(response)

      events = service.call

      expect(events.count).to eq 2
      expect(events[0].name).to eq 'Event1'
      expect(events[0].description).to eq 'Event1 description'
      expect(events[0].start_date).to eq '14-01-2025'
      expect(events[0].end_date).to eq '16-01-2025'
      expect(events[0].event_type).to eq 'in-person'
      expect(events[0].location).to eq 'Palhoça'
      expect(events[0].participant_limit).to eq 20
      expect(events[0].status).to eq 'published'
      expect(events[1].name).to eq 'Event2'
      expect(events[1].description).to eq 'Event2 description'
      expect(events[1].start_date).to eq '15-01-2025'
      expect(events[1].end_date).to eq '17-01-2025'
      expect(events[1].event_type).to eq 'in-person'
      expect(events[1].location).to eq 'Florianópolis'
      expect(events[1].participant_limit).to eq 20
      expect(events[1].status).to eq 'draft'
    end
  end

  it 'when API return not found' do
    service = ExternalEventApi::GetAllEventsService.new(email: 'test@email.com')
    response = instance_double(Faraday::Response, success?: false, body: {})
    allow(Faraday).to receive(:get).and_return(response)

    events = service.call

    expect(events.count).to eq 0
  end

  it 'when Connection Failed exception happens' do
    logger = Rails.logger
    allow(logger).to receive(:error)
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
    service = ExternalEventApi::GetAllEventsService.new(email: 'test@email.com')
    service.call

    expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
  end
end
