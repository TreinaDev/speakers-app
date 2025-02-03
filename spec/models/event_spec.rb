require 'rails_helper'

describe Event do
  context '.all' do
    it 'should get all event information' do
      user = create(:user)
      json = File.read(Rails.root.join('spec/support/events_data.json'))
      response = double('faraday_response', body: json, success?: true)
      allow(Faraday).to receive(:get).and_return(response)

      result = Event.all(user.token)

      expect(result.length).to eq 2
      expect(result[0].name).to eq 'Tech Conference'
      expect(result[0].url).to eq 'www.techconf.com'
      expect(result[0].start_date).to eq '2025-02-01T14:00:00.000-03:00'
      expect(result[0].end_date).to eq '2025-02-05T14:00:00.000-03:00'
      expect(result[0].event_type).to eq 'inperson'
      expect(result[0].address).to eq 'Main Street'
      expect(result[0].participants_limit).to eq 50
      expect(result[0].status).to eq 'draft'
      expect(result[1].name).to eq 'Developer Summit'
      expect(result[1].url).to eq 'www.dev-summit.com'
      expect(result[1].start_date).to eq '2025-03-01T10:00:00.000-03:00'
      expect(result[1].end_date).to eq '2025-03-03T18:00:00.000-03:00'
      expect(result[1].event_type).to eq 'online'
      expect(result[1].address).to eq 'Virtual'
      expect(result[1].participants_limit).to eq 100
      expect(result[1].status).to eq 'published'
    end

    it 'should return zero if not found events' do
      allow(Faraday).to receive(:get).and_return({})

      result = Event.all('teste@email.com')

      expect(result.length).to eq 0
    end
  end

  context '#schedule_items' do
    it 'should get all schedules items associated with event' do
      user = create(:user)
      event = build(:event, name: 'Ruby on Rails')
      speaker_schedule = build(:schedule)
      items = []
      items << build(:schedule_item, name: 'Ruby on Rails', description: 'Introdução a programação')
      items << build(:schedule_item, name: "TDD e introdução a API's", description: 'Desvolvimento Web')
      schedules = [{ schedule: speaker_schedule, schedule_items: items }]
      allow(event).to receive(:schedule_items).and_return(schedules)
      schedule_items = event.schedule_items(user.token)

      expect(schedule_items[0][:schedule_items][0].name).to eq 'Ruby on Rails'
      expect(schedule_items[0][:schedule_items][0].description).to eq 'Introdução a programação'
      expect(schedule_items[0][:schedule_items][1].name).to eq "TDD e introdução a API's"
      expect(schedule_items[0][:schedule_items][1].description).to eq 'Desvolvimento Web'
    end

    it 'raise connection failed error' do
      event = build(:event, name: 'Ruby on Rails')
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      event.schedule_items('ABCD1234')

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end

    it 'raise error' do
      event = build(:event, name: 'Ruby on Rails')
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(StandardError)
      event.schedule_items('ABCD1234')

      expect(logger).to have_received(:error)
    end
  end

  context '#participants' do
    it 'should return a list of all participants' do
      event = build(:event, name: 'Ruby on Rails')
      participants = [
        build(:participant, name: 'João'),
        build(:participant, name: 'Pedro'),
        build(:participant, name: 'Jeremias')
      ]
      allow_any_instance_of(ExternalParticipantApi::EventListParticipantsService).to receive(:call).and_return(participants)

      list = event.participants

      expect(list.count).to eq 3
      expect(list[0].name).to eq 'João'
      expect(list[1].name).to eq 'Pedro'
      expect(list[2].name).to eq 'Jeremias'
    end

    it 'must return zero if not found participants' do
      event = build(:event, name: 'Ruby on Rails')
      participants = []
      allow_any_instance_of(ExternalParticipantApi::EventListParticipantsService).to receive(:call).and_return(participants)

      list = event.participants

      expect(list.count).to eq 0
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
        build(:event, name: "Dev show #{n}", address: "Street #{n}")
      end
      build(:event, name: 'Tech Week', address: 'Rua Fulano de Tal')

      last_event = Event.last

      expect(last_event.name).to eq 'Tech Week'
      expect(last_event.address).to eq 'Rua Fulano de Tal'
      expect(last_event.inspect).not_to include 'Dev show'
      expect(last_event.inspect).not_to include 'Street'
    end

    it 'should return nil if there are no instances' do
      Event.delete_all
      expect(Event.last).to be_nil
    end
  end

  context '.delete_all' do
    it 'must be delete all instances' do
      4.times do |n|
        build(:event, name: "Dev show #{n}")
      end
      Event.delete_all

      expect(Event.count).to eq 0
    end
  end
end
