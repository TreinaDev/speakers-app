FactoryBot.define do
  factory :schedule do
    date { Date.today }
    initialize_with {
      new(date: date)
    }
  end
end
