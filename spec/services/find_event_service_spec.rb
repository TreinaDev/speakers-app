require 'rails_helper'

describe ExternalEventApi::FindEventService do
  context '#find' do
    it 'when API return success' do
      json_event =   {
        "id": 1,
        "name": "Event1",
        "url": "meuevento.com/eventos/Event1",
        "description": "Event1 description",
        "start_date": "14-01-2025",
        "end_date": "16-01-2025",
        "event_type": "in-person",
        "location": "Palhoça",
        "participant_limit": 20,
        "status": "published"
      }
      service = ExternalEventApi::FindEventService.new(json_event['id'])
      response = instance_double(Faraday::Response, success?: true, body: json_event.to_json)
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(Event, :count).by(1)
      event = Event.last
      expect(event.name).to eq 'Event1'
      expect(event.url).to eq 'meuevento.com/eventos/Event1'
      expect(event.description).to eq 'Event1 description'
      expect(event.start_date).to eq '14-01-2025'
      expect(event.end_date).to eq '16-01-2025'
      expect(event.event_type).to eq 'in-person'
      expect(event.location).to eq 'Palhoça'
      expect(event.participant_limit).to eq 20
      expect(event.status).to eq 'published'
    end

    it 'when API return not found' do
      service = ExternalEventApi::FindEventService.new(999999)
      response = instance_double(Faraday::Response, success?: false, body: {})
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(Event, :count).by(0)
    end

    it 'when Connection Failed exception happens' do
      service = ExternalEventApi::FindEventService.new(1)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      expect(Rails.logger).to receive(:error).with(instance_of(Faraday::ConnectionFailed))
      expect(service.call).to be_nil
    end
  end
end
