FactoryBot.define do
  factory :feedback_schedule_item do
    id { generate :id }
    title { Faker::Adjective.positive }
    comment { 'Something' }
    mark { 5 }
    user { Faker::Name.name }
    schedule_item_id { SecureRandom.alphanumeric(8).upcase }

    initialize_with {
      new(id: id, user: user, title: title, comment: comment, mark: mark)
    }
  end
end
