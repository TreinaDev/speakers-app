FactoryBot.define do
  factory :certificate do
    responsable_name { "MyString" }
    speaker_code { "MyString" }
    schedule_item_name { "MyString" }
    event_name { "MyString" }
    date_of_occurrence { "2025-02-08" }
    issue_date { "2025-02-08" }
    length { 1 }
    token { "MyString" }
    user { nil }
  end
end
