require 'rails_helper'

describe ExternalEventApi::FindScheduleItemService do
  context '#call' do
    it 'when API return success' do
      ScheduleItem.delete_all
      json_schedule_item =   {
        "code": "ABCD1234",
        "name": "Ruby on Rails",
        "description": "Testes e TDD",
        "responsible_email": "joao@email.com",
        "start_time": "2025-02-07 13:57:52 UTC",
        "end_time": "2025-02-07 14:57:52 UTC",
        "event": {
          "code": "ABCS1234",
          "start_date": "2025-02-07 13:57:52 UTC",
          "end_date": "2025-02-08 13:57:52 UTC"
        }
      }
      service = ExternalEventApi::FindScheduleItemService.new(schedule_item_id: json_schedule_item['id'], email: json_schedule_item['speaker_email'])
      response = instance_double(Faraday::Response, success?: true, body: json_schedule_item.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      schedule_item = service.call

      expect(ScheduleItem.count).to eq 1
      expect(schedule_item.name).to eq 'Ruby on Rails'
      expect(schedule_item.description).to eq 'Testes e TDD'
      expect(schedule_item.responsible_email).to eq 'joao@email.com'
      expect(schedule_item.event_code).to eq 'ABCS1234'
      expect(schedule_item.event_start_date).to eq '2025-02-07 13:57:52 UTC'
      expect(schedule_item.event_end_date).to eq '2025-02-08 13:57:52 UTC'
    end

    it 'when API return not found' do
      service = ExternalEventApi::FindScheduleItemService.new(schedule_item_id: 999999, email: 'joao@email.com')
      response = instance_double(Faraday::Response, success?: false, body: {})
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(ScheduleItem, :count).by(0)
    end

    it 'when Connection Failed exception happens' do
      ScheduleItem.delete_all
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      service = ExternalEventApi::FindScheduleItemService.new(schedule_item_id: 999999, email: 'joao@email.com')
      service.call

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end
  end
end
