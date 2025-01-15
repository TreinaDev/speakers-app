class Event
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
    result = [ Event.new(id: 1,
                        name: "Event1",
                        url: "",
                        description: "Event1 description",
                        start_date: "14-01-2025",
                        end_date: "16-01-2025",
                        event_type: "in-person",
                        location: "Palhoça",
                        participant_limit: 20,
                        status: "published"),
                    Event.new(id: 2,
                        name: "Event2",
                        url: "",
                        description: "Event2 description",
                        start_date: "15-01-2025",
                        end_date: "17-01-2025",
                        event_type: "in-person",
                        location: "Florianópolis",
                        participant_limit: 20,
                        status: "draft") ]
    begin
      response = Faraday.get("localhost:3001/api/events")

      if response.status == 200
        json = JSON.parse(response.body, symbolize_names: true)[:data]
        result = json.map do |event|
          event = new(id: event[:id], name: event[:name], url: event[:url], description: event[:description],
                      start_date: event[:start_date], end_date: event[:end_date], location: event[:location],
                      participant_limit: event[:participant_limit], status: event[:status])
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
end
