FactoryBot.define do
  factory :certificate do
    user
    responsable_name { user.full_name }
    speaker_code { user.token }
    schedule_item_name { Faker::Name.name }
    schedule_item_code { SecureRandom.alphanumeric(8).upcase }
    event_name { Faker::Name.name }
    date_of_occurrence { 1.day.ago }
    issue_date { Date.current }
    participant_code { SecureRandom.alphanumeric(6).upcase }
    length { rand(60..120) }
    token { SecureRandom.alphanumeric(20).upcase }
    participant_name { Faker::Name.name }
    participant_register { '111.111.111-11' }
  end
end
