module ApiHelper
  class ParticipantClient
    PARTICIPANT_URL = Rails.configuration.participant_api['base'].freeze
    PARTICIPANT_EVENT_LIST = Rails.configuration.participant_api['event_list'].freeze

    def self.get_participant_event_list(event_code)
      url = "#{PARTICIPANT_URL}#{PARTICIPANT_EVENT_LIST}#{event_code}"
      Faraday.get(url)
    end
  end

  class EventClient
    EVENT_URL = Rails.configuration.event_api['base'].freeze
    SCHEDULE_ITEMS_URL = Rails.configuration.event_api['schedule_items']
    SPEAKER_AUTH_URL = Rails.configuration.event_api['speakers_auth']

    def self.get_schedule_items(token:, event_code:)
      url = "#{EVENT_URL}#{SCHEDULE_ITEMS_URL % { token: token, event_code: event_code }}"
      Faraday.get(url)
    end

    def self.post_auth_speaker_email_and_return_code(email)
      connection = Faraday.new do |conn|
        conn.adapter Faraday.default_adapter
        conn.headers['Content-Type'] = 'application/json'
      end
      url = "#{EVENT_URL}#{SPEAKER_AUTH_URL}"
      email = { email: email }
      connection.post(url, email.to_json)
    end
  end
end
