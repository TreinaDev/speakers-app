class ExternalEventApi::FindScheduleItemService < ApplicationService
  def call
    find
  end

  private

  def find
    schedule_item = nil
    begin
      response = EventClient.find_schedule(token: kwargs[:token], schedule_item_code: kwargs[:schedule_item_code])
      if response.success?
        json_response = JSON.parse(response.body)
        schedule_item = ScheduleItem.new(**json_response)
        schedule_item.event_code = json_response["event"]["code"]
        schedule_item.event_start_date = json_response["event"]["start_date"]
        schedule_item.event_end_date = json_response["event"]["end_date"]
        schedule_item.date = date = DateTime.parse(json_response["start_time"]).to_date
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    schedule_item
  end
end
