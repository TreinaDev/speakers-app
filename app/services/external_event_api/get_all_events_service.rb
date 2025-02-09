class ExternalEventApi::GetAllEventsService < ApplicationService
  def call
    get_all_events
  end

  private

  def get_all_events
    results = []
    begin
      response = EventClient.get_all_events(token: kwargs[:token])
      if response.success?
        json_response = JSON.parse(response.body)
        json_response.each do |event|
          results << Event.new(**event)
        end
      end
    rescue StandardError => error
      Rails.logger.error error
    end
    results
  end
end
