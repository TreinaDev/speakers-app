class ExternalParticipantApi::GetEventFeedbacksService < ApplicationService
  def call
    get_event_feedbacks
  end

  private

  def get_event_feedbacks
    feedbacks = []
    begin
      response = Faraday.get('http://localhost:3002/event/feedbacks', { event_id: kwargs[:id], speaker: kwargs[:speaker] })
      if response.success?
        json_response = JSON.parse(response.body)
        json_response.each do |feedback|
          feedbacks << Feedback.new(id: feedback['id'], name: feedback['name'], title: feedback['title'], description: feedback['description'])
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    feedbacks
  end
end
