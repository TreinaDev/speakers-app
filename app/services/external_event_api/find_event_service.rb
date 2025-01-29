class ExternalEventApi::FindEventService < ApplicationService
  def call
    find
  end

  private

  def find
    event = nil
    begin
      response = Faraday.get("http://localhost:3001/api/v1/events/#{ kwargs[:id] }")
      if response.success?
        json_response = JSON.parse(response.body)
        event = Event.new(id: json_response['id'], name: json_response['name'], url: json_response['url'], description: json_response['description'],
                start_date: json_response['start_date'], end_date: json_response['end_date'], event_type: json_response['event_type'],
                location: json_response['location'], participant_limit: json_response['participant_limit'], status: json_response['status'])
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    event
  end
end
