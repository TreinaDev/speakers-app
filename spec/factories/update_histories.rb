FactoryBot.define do
  factory :update_history do
    event_content
    user
    description { "MyText" }
    creation_date { Date.today }
  end
end
