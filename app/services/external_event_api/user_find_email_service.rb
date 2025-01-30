class ExternalEventApi::UserFindEmailService < ApplicationService
  def call
    presence_fetch_api_email?
  end

  private

  def presence_fetch_api_email?
    result = nil
    begin
      connection = Faraday.new do |conn|
        conn.adapter Faraday.default_adapter
        conn.headers['Content-Type'] = 'application/json'
      end
      email = { email: kwargs[:email] }
      response = connection.post('http://localhost:3001/api/v1/speakers', email.to_json)
      if response.success?
        json_response = JSON.parse(response.body)
        result = json_response['token']
      else
        result = JSON.parse(response.body)
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    result
  end
end
