class ExternalParticipantApi::EventListParticipantsService < ApplicationService
  def call
    get_event_participant_list
  end

  private

  def get_event_participant_list
    participants = []
    begin
      response = ParticipantClient.get_participant_event_list(kwargs[:event_code])
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
