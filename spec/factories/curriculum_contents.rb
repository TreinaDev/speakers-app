FactoryBot.define do
  factory :curriculum_content do
    code { SecureRandom.alphanumeric(8).upcase }
    curriculum
    event_content
  end
end
