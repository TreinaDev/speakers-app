require 'rails_helper'

describe ExternalEventApi::ScheduleItemsService do
  context '#where' do
    it 'when API returns success' do
      event = build(:event, name: 'Ruby on Rails')
      email = 'test@email.com'
      service = ExternalEventApi::ScheduleItemsService.new(event_code: event.code, email: email)
      json_response =
      [
        {
          "date": "2025-02-15",
          "activities": [
            {
              "name": "Apresentação",
              "description": "Conheça sobre o fascinante mundo fullstack",
              "start_time": "2025-02-01T18:00:00.000-03:00",
              "end_time": "2025-02-01T19:00:00.000-03:00",
              "responsible_name": "bruno",
              "responsible_email": "speaker2@email.com",
              "schedule_type": "activity"
            },
            {
              "name": "Apresentação",
              "description": "Conheça sobre o fascinante mundo fullstack",
              "start_time": "2025-02-03T16:00:00.000-03:00",
              "end_time": "2025-02-03T18:00:00.000-03:00",
              "responsible_name": "Bruno",
              "responsible_email": "speaker2@email.com",
              "schedule_type": "activity"
            }
          ]
        },
        {
          "date": "2025-02-16",
          "activities": [
            {
              "name": "Outra",
              "description": "Tudo certo",
              "start_time": "2025-02-03T12:00:00.000-03:00",
              "end_time": "2025-02-03T15:00:00.000-03:00",
              "responsible_name": "Bruno",
              "responsible_email": "speaker2@email.com",
              "schedule_type": "activity"
            }
          ]
        }
      ]

      response = instance_double(Faraday::Response, success?: true, body: json_response.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      schedule_data = service.call
      expect(schedule_data.length).to eq 2
      expect(schedule_data[0][:schedule].date).to eq '2025-02-15'
      expect(schedule_data[0][:schedule_items].length).to eq 2
      expect(schedule_data[0][:schedule_items][0].name).to eq 'Apresentação'
      expect(schedule_data[0][:schedule_items][0].description).to eq 'Conheça sobre o fascinante mundo fullstack'
      expect(schedule_data[0][:schedule_items][0].responsible_name).to eq 'bruno'
      expect(schedule_data[0][:schedule_items][0].responsible_email).to eq 'speaker2@email.com'
      expect(schedule_data[0][:schedule_items][1].name).to eq 'Apresentação'
      expect(schedule_data[0][:schedule_items][1].description).to eq 'Conheça sobre o fascinante mundo fullstack'
      expect(schedule_data[0][:schedule_items][1].responsible_name).to eq 'Bruno'
      expect(schedule_data[0][:schedule_items][1].responsible_email).to eq 'speaker2@email.com'
      expect(schedule_data[1][:schedule].date).to eq '2025-02-16'
      expect(schedule_data[1][:schedule_items].length).to eq 1
      expect(schedule_data[1][:schedule_items][0].name).to eq 'Outra'
      expect(schedule_data[1][:schedule_items][0].description).to eq 'Tudo certo'
      expect(schedule_data[1][:schedule_items][0].responsible_name).to eq 'Bruno'
      expect(schedule_data[1][:schedule_items][0].responsible_email).to eq 'speaker2@email.com'
    end

    it 'when API return not found' do
      ScheduleItem.delete_all
      service = ExternalEventApi::ScheduleItemsService.new(event_code: 999999, email: 'abc@email.com')
      response = instance_double(Faraday::Response, success?: false, body: {})
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(ScheduleItem, :count).by(0)
    end

    it 'when Connection Failed exception happens' do
      ScheduleItem.delete_all
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      service = ExternalEventApi::ScheduleItemsService.new(event_code: 1, email: 'abc@email.com')
      service.call

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end
  end
end
