FactoryBot.define do
  factory :event_content do
    code { SecureRandom.alphanumeric(8).upcase }
    title { "MyString" }
    description { "MyText" }
    user
  end
end
