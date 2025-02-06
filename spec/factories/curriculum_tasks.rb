FactoryBot.define do
  factory :curriculum_task do
    code { SecureRandom.alphanumeric(8).upcase }
    curriculum
    title { "MyString" }
    description { "MyText" }
    certificate_requirement { 1 }
  end
end
