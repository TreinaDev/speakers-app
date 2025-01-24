require 'rails_helper'

describe ExternalEventApi::ScheduleItemsService do
  context '#where' do
    it 'when API return success' do
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
                    start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
                    event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      email = 'test@email.com'
      service = ExternalEventApi::ScheduleItemsService.new(event.id, email)
      json_response =

        {
          "schedule_items": [
            {
              "id": 1,
              "start_time": "2000-01-01T11:00:00.000Z",
              "lenght": 45,
              "title": "Title 1",
              "description": "Something 1",
              "speaker_email": "speaker0@email.com",
              "schedule_id": 1,
              "created_at": "2025-01-22T19:04:25.408Z",
              "updated_at": "2025-01-22T19:04:25.408Z"
            },
            {
              "id": 2,
              "start_time": "2000-01-01T14:00:00.000Z",
              "lenght": 90,
              "title": "Title 2",
              "description": "Something 2",
              "speaker_email": "speaker0@email.com",
              "schedule_id": 1,
              "created_at": "2025-01-22T19:04:25.416Z",
              "updated_at": "2025-01-22T19:04:25.416Z"
            },
            {
              "id": 3,
              "start_time": "2000-01-01T11:00:00.000Z",
              "lenght": 120,
              "title": "Title 3",
              "description": "Something 3",
              "speaker_email": "speaker0@email.com",
              "schedule_id": 2,
              "created_at": "2025-01-22T19:04:25.422Z",
              "updated_at": "2025-01-22T19:04:25.422Z"
            }
          ]
        }

      response = instance_double(Faraday::Response, success?: true, body: json_response.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      schedule_items = service.call

      expect(schedule_items.length).to eq 3
      expect(schedule_items[0].title).to eq 'Title 1'
      expect(schedule_items[0].description).to eq 'Something 1'
      expect(schedule_items[1].title).to eq 'Title 2'
      expect(schedule_items[1].description).to eq 'Something 2'
      expect(schedule_items[2].title).to eq 'Title 3'
      expect(schedule_items[2].description).to eq 'Something 3'
    end

    it 'when API return not found' do
      ScheduleItem.delete_all
      service = ExternalEventApi::ScheduleItemsService.new(999999, 'abc@email.com')
      response = instance_double(Faraday::Response, success?: false, body: {})
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(ScheduleItem, :count).by(0)
    end

    it 'when Connection Failed exception happens' do
      ScheduleItem.delete_all
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      service = ExternalEventApi::ScheduleItemsService.new(1, 'abc@email.com')
      service.call

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end
  end
end
