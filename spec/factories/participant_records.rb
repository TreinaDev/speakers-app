FactoryBot.define do
  factory :participant_record do
    participant_code { "MyString" }
    user { nil }
    schedule_item_code { "MyString" }
    enabled_certificate { false }
  end
end
