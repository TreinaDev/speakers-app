FactoryBot.define do
  factory :feedback do
    id { generate :id }
    name { Faker::Name.name }
    title { Faker::Adjective.positive }
    description { 'Something' }

    initialize_with {
      new(id: id, name: name, title: title, description: description)
    }
  end
end
