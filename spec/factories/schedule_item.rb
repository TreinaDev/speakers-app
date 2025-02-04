FactoryBot.define do
  factory :schedule_item do
    name { "Schedule" }
    description { "Something" }
    responsible_name { Faker::Name.name }
    code { SecureRandom.alphanumeric(8).upcase }
    responsible_email { generate :email }
    schedule_type { 'in-person' }
    start_time { 1.days.from_now }
    end_time { 2.days.from_now }

    initialize_with {
      new(name: name, description: description, responsible_name: responsible_name, responsible_email: responsible_email, schedule_type: schedule_type,
          start_time: start_time, end_time: end_time, code: code)
    }
  end
end
