class ExternalEventApi::FindScheduleItemService < ApplicationService
  def call
    find
  end

  private

  def find
    schedule_item = nil
    begin
      response = Faraday.get("http://localhost:3001/api/v1/schedule_items/teste", { email: kwargs[:email], schedule_item_id: kwargs[:schedule_item_id] })
      if response.success?
        json_response = JSON.parse(response.body)
        schedule_item = ScheduleItem.new(id: json_response['id'], title: json_response['title'], speaker_email: json_response['speaker_email'], description: json_response['description'], length: json_response['length'])
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    schedule_item
  end
end
