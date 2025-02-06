FactoryBot.define do
  factory :feedback do
    id { generate :id }
    user { Faker::Name.name }
    title { Faker::Adjective.positive }
    comment { 'Something' }
    mark { 5 }

    initialize_with {
      new(id: id, user: user, title: title, comment: comment, mark: mark)
    }
  end
end
