FactoryBot.define do
  factory :event do
    name { "Tech Conference" }
    url { "www.techconf.com" }
    description { "Something" }
    start_date { "2025-02-01T14:00:00.000-03:00" }
    end_date { end_time_rand }
    event_type { "inperson" }
    location { "Main Street" }
    participants_limit { 50 }
    status { "published" }
    created_at { "2025-01-31T16:24:11.521-03:00" }
    updated_at { "2025-01-31T16:24:11.534-03:00" }
    code { SecureRandom.alphanumeric(8).upcase }

    initialize_with {
      new(name: name, url: url, description: description, start_date: start_date,
       end_date: end_date, event_type: event_type, location: location, participants_limit: participants_limit,
       status: status, created_at: created_at, updated_at: updated_at, code: code)
    }
  end
end

def end_time_rand
  rand(11..20).day.from_now
end
