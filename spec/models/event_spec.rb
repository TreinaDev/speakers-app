require 'rails_helper'

describe Event do
  context '.all' do
    it 'should get all event information' do
      json = File.read(Rails.root.join('spec/support/events_data.json'))
      response = double('faraday_response', body: json, success?: true)
      allow(Faraday).to receive(:get).and_return(response)

      result = Event.all('teste@email.com')

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

    it 'should return zero if not found events' do
      allow(Faraday).to receive(:get).and_return({})

      result = Event.all('teste@email.com')

      expect(result.length).to eq 0
    end
  end

  context '.find' do
    it 'should return an event if present in instances' do
      Event.delete_all
      json = [
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
      response_all = double('faraday_response', body: json.to_json, success?: true)
      allow(Faraday).to receive(:get).and_return(response_all)

      Event.all('teste@email.com')
      event = Event.find(1)

      expect(Event.count).to eq 2
      expect(event.id).to eq 1
      expect(event.name).to eq 'Event1'
      expect(event.url).to eq ''
      expect(event.description).to eq 'Event1 description'
      expect(event.start_date).to eq '14-01-2025'
      expect(event.end_date).to eq '16-01-2025'
      expect(event.event_type).to eq 'in-person'
      expect(event.location).to eq 'Palhoça'
      expect(event.participant_limit).to eq 20
      expect(event.status).to eq 'published'
    end

    it 'should perform a GET request to locate the event if not found in the instances' do
      Event.delete_all
      json = {
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
            }
      response_find = double('faraday_response', body: json.to_json, success?: true)
      allow(Event).to receive(:find_instance).and_return(nil)
      allow(Faraday).to receive(:get).and_return(response_find)

      event = Event.find(1)

      expect(event.id).to eq 1
      expect(event.name).to eq 'Event1'
      expect(event.url).to eq ''
      expect(event.description).to eq 'Event1 description'
      expect(event.start_date).to eq '14-01-2025'
      expect(event.end_date).to eq '16-01-2025'
      expect(event.event_type).to eq 'in-person'
      expect(event.location).to eq 'Palhoça'
      expect(event.participant_limit).to eq 20
      expect(event.status).to eq 'published'
    end

    it 'should return nil if not found' do
      Event.delete_all

      event = Event.find(99999)

      expect(Event.count).to eq 0
      expect(event).to be_nil
    end
  end

  context '#schedule_items' do
    it 'should get all schedules items associated with event' do
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
              start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
              event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      items = [
        build(:schedule_item, title: 'Ruby on Rails', description: 'Introdução a programação'),
        build(:schedule_item, title: "TDD e introdução a API's", description: 'Desvolvimento Web')
      ]
      allow(event).to receive(:schedule_items).and_return(items)
      schedule_items = event.schedule_items('teste@email.com')

      expect(schedule_items[0].title).to eq 'Ruby on Rails'
      expect(schedule_items[0].description).to eq 'Introdução a programação'
      expect(schedule_items[1].title).to eq "TDD e introdução a API's"
      expect(schedule_items[1].description).to eq 'Desvolvimento Web'
    end

    it 'raise connection failed error' do
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
              start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
              event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      event.schedule_items('teste@email.com')

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end

    it 'raise error' do
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
                    start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
                    event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(StandardError)
      event.schedule_items('teste@email.com')

      expect(logger).to have_received(:error).with("Erro: StandardError")
    end
  end

  context '.count' do
    it 'should return a count of all instances' do
      Event.delete_all
      10.times do
        build(:event)
      end

      expect(Event.count).to eq 10
    end

    it 'should return zero if there are no instances' do
      Event.delete_all
      expect(Event.count).to eq 0
    end
  end

  context '.last' do
    it 'must return the last instance' do
      Event.delete_all
      4.times do |n|
        build(:event, name: "Dev show #{n}", description: "Take #{n}")
      end
      build(:event, name: 'Tech Week', description: 'Desenvolvimento guiado por testes.')

      last_event = Event.last

      expect(last_event.name).to eq 'Tech Week'
      expect(last_event.description).to eq 'Desenvolvimento guiado por testes.'
      expect(last_event.inspect).not_to include 'Dev show'
      expect(last_event.inspect).not_to include 'Take'
    end

    it 'should return nil if there are no instances' do
      Event.delete_all
      expect(Event.last).to be_nil
    end
  end

  context '.delete_all' do
    it 'must be delete all instances' do
      4.times do |n|
        build(:event, name: "Dev show #{n}", description: "Take #{n}")
      end
      Event.delete_all

      expect(Event.count).to eq 0
    end
  end
end
