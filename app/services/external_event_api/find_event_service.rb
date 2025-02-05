class ExternalEventApi::FindEventService < ApplicationService
  def call
    find
  end

  private

  def find
    event = nil
    begin
      response = Faraday.get("http://localhost:3001/api/v1/speakers/#{ kwargs[:token] }/event/#{ kwargs[:code] }")
      if response.success?
        event = Event.new(**JSON.parse(response.body))
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    event
  end
end
