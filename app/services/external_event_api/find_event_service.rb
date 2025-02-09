class ExternalEventApi::FindEventService < ApplicationService
  def call
    find
  end

  private

  def find
    event = nil
    begin
      response = EventClient.find_event(token: kwargs[:token], event_code: kwargs[:code])
      if response.success?
        event = Event.new(**JSON.parse(response.body))
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    event
  end
end
