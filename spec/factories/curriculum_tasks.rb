FactoryBot.define do
  factory :curriculum_task do
    curriculum
    title { "MyString" }
    description { "MyText" }
    certificate_requirement { 1 }
  end
end
