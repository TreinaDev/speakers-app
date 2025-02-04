class ExternalEventApi::ScheduleItemsService < ApplicationService
  def call
    get_user_schedule_items
  end

  private

  def get_user_schedule_items
    result = []
    begin
      response = EventClient.get_schedule_items(token: kwargs[:token], event_code: kwargs[:event_code])
      json_response = JSON.parse(response.body)
      result = json_response.map do |schedule|
        items = []
        speaker_schedule = Schedule.new(date: schedule['date'])
        schedule['activities'].each do |item|
          items << ScheduleItem.new(**item)
        end
        { schedule: speaker_schedule, schedule_items: items }
      end
    rescue StandardError => error
      Rails.logger.error error
    end
    result
  end
end
