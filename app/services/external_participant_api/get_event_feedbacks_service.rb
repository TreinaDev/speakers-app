class ExternalParticipantApi::GetEventFeedbacksService < ApplicationService
  def call
    get_event_feedbacks
  end

  private

  def get_event_feedbacks
    feedbacks = []
    begin
      response = Faraday.get("http://localhost:3002/api/v1/events/#{kwargs[:event_code]}/feedbacks")
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
