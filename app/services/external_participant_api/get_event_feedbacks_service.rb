class ExternalParticipantApi::GetEventFeedbacksService < ApplicationService
  def call
    get_event_feedbacks
  end

  private

  def get_event_feedbacks
    feedbacks = []
    begin
      response = ParticipantClient.event_feedbacks(event_code: kwargs[:event_code])
      if response.success?
        json_response = JSON.parse(response.body)
        json_response['feedbacks'].each do |feedback|
          feedbacks << Feedback.new(**feedback)
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    feedbacks
  end
end
