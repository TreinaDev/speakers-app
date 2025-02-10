FactoryBot.define do
  factory :schedule_item do
    name { "Schedule" }
    date { 1.days.from_now }
    description { "Something" }
    responsible_name { Faker::Name.name }
    code { SecureRandom.alphanumeric(8).upcase }
    responsible_email { generate :email }
    schedule_type { 'in-person' }
    start_time { 1.days.from_now }
    end_time { 2.days.from_now }
    event_code { SecureRandom.alphanumeric(8).upcase }
    event_start_date { start_time_rand }
    event_end_date { end_time_rand }

    initialize_with {
      new(name: name, description: description, responsible_name: responsible_name, responsible_email: responsible_email, schedule_type: schedule_type,
          start_time: start_time, end_time: end_time, code: code, event_code: event_code, event_start_date: event_start_date, event_end_date: event_end_date)
    }
  end
end

def start_time_rand
  rand(1..10).day.from_now
end

def end_time_rand
  rand(11..20).day.from_now
end
