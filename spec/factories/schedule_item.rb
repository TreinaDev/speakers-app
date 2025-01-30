FactoryBot.define do
  factory :schedule_item do
    id { generate :id }
    title { "Schedule #{ id }" }
    description { "Something" }
    speaker_email { generate :email }
    length { rand(45..120) }
    start_time { 1.day.from_now }

    initialize_with {
      new(id: id, title: title, speaker_email: speaker_email, description: description, length: length, start_time: start_time)
    }
  end
end
