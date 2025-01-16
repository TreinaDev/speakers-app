class ExternalEventApi::UserFindEmailService
  def initialize(email)
    @email = email
  end

  def self.find_email
    new(email).find_email
  end

  def find_email
    presence_fetch_api_email?
  end

  private

  attr_reader :email

  def presence_fetch_api_email?
    begin
      Faraday.get("http://localhost:3001/events/speakers?email=#{ email }").success?
    rescue StandardError => error
      Rails.logger.error(error)
      false
    end
  end
end

