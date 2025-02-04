class ExternalEventApi::UserFindEmailService < ApplicationService
  def call
    presence_fetch_api_email?
  end

  private

  def presence_fetch_api_email?
    result = nil
    begin
      response = EventClient.post_auth_speaker_email_and_return_code(kwargs[:email])
      result = JSON.parse(response.body)
    rescue StandardError => error
      Rails.logger.error(error)
    end
    result
  end
end
