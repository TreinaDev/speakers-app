FactoryBot.define do
  factory :event_task do
    name { "MyString" }
    description { "MyText" }
    status { 1 }
    is_mandatory { 1 }
  end
end
