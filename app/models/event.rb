class Event
  extend ActiveModel::Translation

  attr_accessor :id, :name, :url, :description, :start_date, :end_date, :event_type, :location, :participant_limit, :status

  def initialize(id:, name:, url:, description:, start_date:, end_date:, event_type:, location:, participant_limit:, status:)
    @id = id
    @name = name
    @url = url
    @description = description
    @start_date = start_date
    @end_date = end_date
    @event_type = event_type
    @location = location
    @participant_limit = participant_limit
    @status = status
  end


  def self.all
    result = []
    begin
      response = Faraday.get("http://localhost:3001/api/v1/events")

      if response.status == 200
        json = JSON.parse(response.body)
        result = json.map do |event|
          new(id: event['id'], name: event['name'], url: event['url'], description: event['description'],
              start_date: event['start_date'], end_date: event['end_date'], event_type: event['event_type'],
              location: event['location'], participant_limit: event['participant_limit'], status: event['status'])
        end
        return result
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error e
    rescue => e
      Rails.logger.error "Erro: #{e}"
    end
    result
  end

  def self.find(id)
    ExternalEventApi::FindEventService.call(id)
  end

  def schedule_items(email)
    ExternalEventApi::ScheduleItemsService.call(id, email)
  end
end
