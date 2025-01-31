require 'rails_helper'

describe ExternalEventApi::FindEventService do
  context '#call' do
    it 'when API return success' do
      json_event = {
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
      }
      service = ExternalEventApi::FindEventService.new(code: json_event[:code])
      response = instance_double(Faraday::Response, success?: true, body: json_event.to_json)
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(Event, :count).by(1)
      event = Event.last
      expect(event.name).to eq 'Tech Conference'
      expect(event.url).to eq 'www.techconf.com'
      expect(event.start_date).to eq DateTime.parse('2025-02-01T14:00:00.000-03:00')
      expect(event.end_date).to eq DateTime.parse('2025-02-05T14:00:00.000-03:00')
      expect(event.event_type).to eq 'inperson'
      expect(event.address).to eq 'Main Street'
      expect(event.participants_limit).to eq 50
      expect(event.status).to eq 'draft'
    end

    it 'when API return not found' do
      service = ExternalEventApi::FindEventService.new(code: 999999)
      response = instance_double(Faraday::Response, success?: false, body: {})
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(Event, :count).by(0)
    end

    it 'when Connection Failed exception happens' do
      service = ExternalEventApi::FindEventService.new(code: 1)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      expect(Rails.logger).to receive(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(service.call).to be_nil
    end
  end
end
