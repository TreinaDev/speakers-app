FactoryBot.define do
  factory :participant do
    id { generate :id }
    name { Faker::Name.name  }

    initialize_with {
      new(id: id, name: name)
    }
  end
end
