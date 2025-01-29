class ExternalEventApi::GetAllEventsService < ApplicationService
  def call
    get_all_events
  end

  private

  def get_all_events
    results = []
    begin
      response = Faraday.get("http://localhost:3001/events/speaker_events", { email: kwargs[:email] })
      if response.success?
        json = JSON.parse(response.body)
        json.each do |event|
        results << Event.new(id: event['id'], name: event['name'], url: event['url'], description: event['description'],
                        start_date: event['start_date'], end_date: event['end_date'], event_type: event['event_type'],
                        location: event['location'], participant_limit: event['participant_limit'], status: event['status'])
        end
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error e
    rescue => e
      Rails.logger.error "Erro: #{e}"
    end
    results
  end
end
