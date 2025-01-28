FactoryBot.define do
  factory :curriculum do
    user
    schedule_item_code { SecureRandom.alphanumeric(8) }
  end
end
