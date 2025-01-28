FactoryBot.define do
  factory :schedule_item do
    id { generate :id }
    title { "Schedule #{ id }" }
    description { "Something" }
    speaker_email { generate :email }
    length { rand(45..120) }

    initialize_with {
      new(id: id, title: title, speaker_email: speaker_email, description: description, length: length)
    }
  end
end
