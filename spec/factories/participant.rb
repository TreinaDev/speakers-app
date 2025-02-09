FactoryBot.define do
  factory :participant do
    id { generate :id }
    name { Faker::Name.name  }
    cpf { '111.111.111-11' }
    email { 'example@email.com' }
    code { SecureRandom.alphanumeric(6) }

    initialize_with {
      new(id: id, name: name, cpf: cpf, email: email, code: code)
    }
  end
end
