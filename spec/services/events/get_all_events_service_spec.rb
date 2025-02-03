require 'rails_helper'

describe ExternalEventApi::GetAllEventsService do
  context '#call' do
    it 'when api return success' do
      json_response = [
        {
          "name": "Tech Conference",
          "event_type": "inperson",
          "address": "Main Street",
          "participants_limit": 50,
          "url": "www.techconf.com",
          "status": "draft",
          "created_at": "2025-01-31T16:24:11.521-03:00",
          "updated_at": "2025-01-31T16:24:11.534-03:00",
          "code": "ABC123XYZ",
          "start_date": "2025-02-01T14:00:00.000-03:00",
          "end_date": "2025-02-05T14:00:00.000-03:00"
        },
        {
          "name": "Developer Summit",
          "event_type": "online",
          "address": "Virtual",
          "participants_limit": 100,
          "url": "www.dev-summit.com",
          "status": "published",
          "created_at": "2025-01-31T16:24:11.521-03:00",
          "updated_at": "2025-01-31T16:24:11.534-03:00",
          "code": "XYZ789ABC",
          "start_date": "2025-03-01T10:00:00.000-03:00",
          "end_date": "2025-03-03T18:00:00.000-03:00"
        }
      ]

      service = ExternalEventApi::GetAllEventsService.new(token: 'ABCD1234')
      response = instance_double(Faraday::Response, success?: true, body: json_response.to_json)
      allow(Faraday).to receive(:get).and_return(response)

      events = service.call
      expect(events.count).to eq 2
      expect(events[0].name).to eq 'Tech Conference'
      expect(events[0].event_type).to eq 'inperson'
      expect(events[0].address).to eq 'Main Street'
      expect(events[0].participants_limit).to eq 50
      expect(events[0].url).to eq 'www.techconf.com'
      expect(events[0].status).to eq 'draft'
      expect(events[0].start_date).to eq '2025-02-01T14:00:00.000-03:00'
      expect(events[0].end_date).to eq '2025-02-05T14:00:00.000-03:00'
      expect(events[1].name).to eq 'Developer Summit'
      expect(events[1].event_type).to eq 'online'
      expect(events[1].address).to eq 'Virtual'
      expect(events[1].participants_limit).to eq 100
      expect(events[1].url).to eq 'www.dev-summit.com'
      expect(events[1].status).to eq 'published'
      expect(events[1].start_date).to eq '2025-03-01T10:00:00.000-03:00'
      expect(events[1].end_date).to eq '2025-03-03T18:00:00.000-03:00'
    end
  end

  it 'when API return not found' do
    service = ExternalEventApi::GetAllEventsService.new(token: 'ABCD1234')
    response = instance_double(Faraday::Response, success?: false, body: {})
    allow(Faraday).to receive(:get).and_return(response)

    events = service.call

    expect(events.count).to eq 0
  end

  it 'when Connection Failed exception happens' do
    logger = Rails.logger
    allow(logger).to receive(:error)
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
    service = ExternalEventApi::GetAllEventsService.new(token: 'ABCD1234')
    service.call

    expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
  end
end
