class ExternalEventApi::ScheduleItemsService
  def initialize(event_id, email)
    @event_id = event_id
    @email = email
  end

  def self.call(event_id, email)
    new(event_id, email).call
  end

  def call
    where
  end

  private

  attr_reader :event_id, :email

  def where
    result = []
    begin
      response = Faraday.get('http://localhost:3001/events/schedule_items', { email: email, event_id: event_id })
      if response.success?
        schedule_items = JSON.parse(response.body)
        result = schedule_items['schedule_items'].map do |item|
          ScheduleItem.new(id: item['id'], title: item['title'], description: item['description'], speaker_email: item['speaker_email'], lenght: item['lenght'])
        end
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error e
    rescue => e
      Rails.logger.error "Erro: #{e}"
    end
    result
  end
end
