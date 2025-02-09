FactoryBot.define do
  factory :participant_record do
    participant_code { SecureRandom.alphanumeric(8).upcase }
    user
    schedule_item_code { SecureRandom.alphanumeric(8).upcase }
    enabled_certificate { false }
  end
end
