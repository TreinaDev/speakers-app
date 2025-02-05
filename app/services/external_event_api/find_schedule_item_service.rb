class ExternalEventApi::FindScheduleItemService < ApplicationService
  def call
    find
  end

  private

  def find
    schedule_item = nil
    begin
      response = Faraday.get("http://localhost:3001/api/v1/speakers/#{ kwargs[:token] }/schedule_item/#{ kwargs[:schedule_item_code] }")
      if response.success?
        json_response = JSON.parse(response.body)
        schedule_item = ScheduleItem.new(**json_response)
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    schedule_item
  end
end
