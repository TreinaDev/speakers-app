class ExternalEventApi::ScheduleItemsService < ApplicationService
  def call
    get_user_schedule_items
  end

  private

  def get_user_schedule_items
    result = []
    begin
      response = Faraday.get('http://localhost:3001/events/schedule_items', { email: kwargs[:email], event_id: kwargs[:event_id] })
      if response.success?
        schedule_items = JSON.parse(response.body)
        result = schedule_items['schedule_items'].map do |item|
          ScheduleItem.new(id: item['id'], title: item['title'], description: item['description'], speaker_email: item['speaker_email'], length: item['length'])
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
