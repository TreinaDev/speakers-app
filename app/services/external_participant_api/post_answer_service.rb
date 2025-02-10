class ExternalParticipantApi::PostAnswerService < ApplicationService
  def call
    feedback_answer
  end

  private

  def feedback_answer
    begin
      ParticipantClient.post_answer(feedback_id: kwargs[:feedback_id], name: kwargs[:name], email: kwargs[:email], answer: kwargs[:answer]).success?
    rescue StandardError => error
      Rails.logger.error(error)
      false
    end
  end
end
