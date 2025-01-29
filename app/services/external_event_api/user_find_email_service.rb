class ExternalEventApi::UserFindEmailService < ApplicationService
  def call
    presence_fetch_api_email?
  end

  private

  def presence_fetch_api_email?
    token = nil
    begin
      response = Faraday.post('http://localhost:3001/api/v1/speakers', { email: kwargs[:email] })
      if response.success?
        json_response = JSON.parse(response.body)
        token = json_response['token']
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    token
  end
end
