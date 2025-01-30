class ExternalParticipantApi::EventListParticipantsService < ApplicationService
  def call
    get_event_participant_list
  end

  private

  def get_event_participant_list
    participants = []
    begin
      response = Faraday.get('http://localhost:3002/events/participants', { event_id: kwargs[:event_id] })
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