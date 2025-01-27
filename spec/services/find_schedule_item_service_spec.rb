require 'rails_helper'

describe ExternalEventApi::FindScheduleItemService do
  context '#find' do
    it 'when API return success' do
      ScheduleItem.delete_all
      json_schedule_item =   {
        "id": 1,
        "title": "Ruby on Rails",
        "description": "Testes e TDD",
        "speaker_email": "joao@email.com",
        "length": 100
      }
      service = ExternalEventApi::FindScheduleItemService.new(json_schedule_item['id'], json_schedule_item['speaker_email'])
      response = instance_double(Faraday::Response, success?: true, body: json_schedule_item.to_json)
      allow(Faraday).to receive(:get).and_return(response)
      schedule_item = service.call

      expect(ScheduleItem.count).to eq 1
      expect(schedule_item.title).to eq 'Ruby on Rails'
      expect(schedule_item.description).to eq 'Testes e TDD'
      expect(schedule_item.speaker_email).to eq 'joao@email.com'
      expect(schedule_item.length).to eq 100
    end

    it 'when API return not found' do
      service = ExternalEventApi::FindScheduleItemService.new(999999, 'joao@email.com')
      response = instance_double(Faraday::Response, success?: false, body: {})
      allow(Faraday).to receive(:get).and_return(response)

      expect { service.call }.to change(ScheduleItem, :count).by(0)
    end

    it 'when Connection Failed exception happens' do
      ScheduleItem.delete_all
      logger = Rails.logger
      allow(logger).to receive(:error)
      allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
      service = ExternalEventApi::FindScheduleItemService.new(999999, 'joao@email.com')
      service.call

      expect(logger).to have_received(:error).with(instance_of(Faraday::ConnectionFailed))
    end
  end
end
