FactoryBot.define do
  factory :event_content do
    title { "MyString" }
    description { "MyText" }
    user
  end
end
