class ExternalEventApi::GetAllEventsService < ApplicationService
  def call
    get_all_events
  end

  private

  def get_all_events
    results = []
    begin
      response = Faraday.get("http://localhost:3001/api/v1/speakers/#{ kwargs[:token] }/events")
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
