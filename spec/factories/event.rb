FactoryBot.define do
  factory :event do
    id { generate :id }
    name { "Event #{ id }" }
    url { "localhost:3001/events/#{ id }" }
    description { "Something" }
    start_date { start_time_rand }
    end_date { end_time_rand }
    event_type { "in-person" }
    location { "Toowoomba" }
    participant_limit { 30 }
    status { "draft" }

    initialize_with {
      new(id: id, name: name, url: url, description: description, start_date: start_date,
       end_date: end_date, event_type: event_type, location: location, participant_limit: participant_limit, status: status)
    }
  end
end

def start_time_rand
  rand(1..10).day.from_now
end

def end_time_rand
  rand(11..20).day.from_now
end
