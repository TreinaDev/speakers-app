module ApiHelper
  class ParticipantClient
    PARTICIPANT_URL = 'http://localhost:3001/api/v1/'.freeze
    PARTICIPANT_EVENT_LIST = 'events/'.freeze
    EVENT_FEEDBACKS_URL = 'events/%{event_code}/feedbacks'
    SCHEDULE_ITEMS_FEEDBACKS_URL = 'schedule_items/%{schedule_item_id}/item_feedbacks'
    FIND_PARTICIPANT_URL = 'users/'
    POST_ANSWER_URL = 'item_feedbacks/%{id}/feedback_answers'

    def self.get_participant_event_list(event_code)
      url = "#{PARTICIPANT_URL}#{PARTICIPANT_EVENT_LIST}#{ event_code }"
      Faraday.get(url)
    end

    def self.post_answer(feedback_id:, name:, email:, answer:)
      connection = Faraday.new do |conn|
        conn.adapter Faraday.default_adapter
        conn.headers['Content-Type'] = 'application/json'
      end
      url = "#{PARTICIPANT_URL}#{POST_ANSWER_URL % { id: feedback_id }}"
      data = {
        feedback_answer: {
          name: name,
          email: email,
          comment: answer
        }
       }
      connection.post(url, data.to_json)
    end

    def self.event_feedbacks(event_code:)
      url = "#{PARTICIPANT_URL}#{EVENT_FEEDBACKS_URL % { event_code: event_code }}"
      Faraday.get(url)
    end

    def self.schedule_item_feedbacks(schedule_item_id:)
      url = "#{PARTICIPANT_URL}#{SCHEDULE_ITEMS_FEEDBACKS_URL % { schedule_item_id: schedule_item_id }}"
      Faraday.get(url)
    end

    def self.find_participant(participant_code:)
      url = "#{PARTICIPANT_URL}#{FIND_PARTICIPANT_URL}#{ participant_code }"
      Faraday.get(url)
    end
  end

  class EventClient
    EVENT_URL = 'http://localhost:3003/api/v1/'.freeze
    SCHEDULE_ITEMS_URL = 'speakers/%{token}/schedules/%{event_code}'
    SPEAKER_AUTH_URL = 'speakers'
    FIND_EVENT_URL = 'speakers/%{token}/event/%{event_code}'
    FIND_SCHEDULE_URL = 'speakers/%{token}/schedule_item/%{schedule_item_code}'
    ALL_EVENTS_URL = 'speakers/%{token}/events'

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

    def self.find_event(token:, event_code:)
      url = "#{EVENT_URL}#{FIND_EVENT_URL % { token: token, event_code: event_code }}"
      Faraday.get(url)
    end

    def self.find_schedule(token:, schedule_item_code:)
      url = "#{EVENT_URL}#{FIND_SCHEDULE_URL % { token: token, schedule_item_code: schedule_item_code }}"
      Faraday.get(url)
    end

    def self.get_all_events(token:)
      Faraday.get("#{EVENT_URL}#{ALL_EVENTS_URL % { token: token }}")
    end
  end
end
