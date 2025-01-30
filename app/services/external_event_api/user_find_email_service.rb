class ExternalEventApi::UserFindEmailService < ApplicationService
  def call
    presence_fetch_api_email?
  end

  private

  def presence_fetch_api_email?
    begin
      Faraday.get("http://localhost:3001/events/speakers", { email: kwargs[:email] }).success?
    rescue StandardError => error
      Rails.logger.error(error)
      false
    end
  end
end
