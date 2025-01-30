class ExternalParticipantApi::ListParticipantsService < ApplicationService
  def call
    get_list_of_participants
  end

  private

  attr_reader :schedule_item_id

  def get_list_of_participants
    participants = []
    begin
      response = Faraday.get('http://localhost:3002/schedule_items/participants', { schedule_item_id: kwargs[:schedule_item_id] })
      if response.success?
        json_response = JSON.parse(response.body)
        json_response.each do |participant|
          participants << Participant.new(id: participant['id'], name: participant['name'])
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    participants
  end
end
