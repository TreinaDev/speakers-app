FactoryBot.define do
  sequence(:email) { |n| "user#{n}@email.com" }
end
