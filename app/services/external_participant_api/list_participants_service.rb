class ExternalParticipantApi::ListParticipantsService < ApplicationService
  def call
    get_list_of_participants
  end

  private

  def get_list_of_participants
    participants = []
    begin
      response = Faraday.get('http://localhost:3002/schedule_items/participants', { schedule_item_code: kwargs[:schedule_item_code] })
      if response.success?
        json_response = JSON.parse(response.body)
        json_response['participants'].each do |participant|
          participants << Participant.new(**participant)
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    participants
  end
end
