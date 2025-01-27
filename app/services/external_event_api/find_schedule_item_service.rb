class ExternalEventApi::FindScheduleItemService
  def initialize(schedule_item_id, email)
    @schedule_item_id = schedule_item_id
    @email = email
  end

  def self.call(schedule_item_id, email)
    new(schedule_item_id, email).call
  end

  def call
    find
  end

  private

  attr_reader :schedule_item_id, :email

  def find
    schedule_item = nil
    begin
      response = Faraday.get("http://localhost:3001/api/v1/schedule_items/teste", { email: email, schedule_item_id: schedule_item_id })
      if response.success?
        json_response = JSON.parse(response.body)
        schedule_item = ScheduleItem.new(id: json_response['id'], title: json_response['title'], speaker_email: json_response['speaker_email'], description: json_response['description'], length: json_response['length'])
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    schedule_item
  end
end
