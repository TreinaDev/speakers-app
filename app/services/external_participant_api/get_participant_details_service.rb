class ExternalParticipantApi::GetParticipantDetailsService < ApplicationService
  def call
    get_participante_details
  end

  private

  def get_participante_details
    participant = nil
    begin
      response = ParticipantClient.find_participant(participant_code: kwargs[:participant_code])
      if response.success?
        participant = Participant.new(**JSON.parse(response.body))
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    participant
  end
end
