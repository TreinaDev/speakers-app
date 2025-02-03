module ApiHelper
  class ParticipantClient
    PARTICIPANT_URL = Rails.configuration.participant_api['base'].freeze
    PARTICIPANT_EVENT_LIST = Rails.configuration.participant_api['event_list'].freeze

    def self.get_participant_event_list(event_code)
      url = "#{ PARTICIPANT_URL }#{ PARTICIPANT_EVENT_LIST }#{ event_code }"
      Faraday.get(url)
    end
  end
end
