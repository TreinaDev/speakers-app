FactoryBot.define do
  factory :profile do
    title { "Instrutor" }
    about_me { "Minha vida pessoal" }
    user
    city { "Florianópolis" }
    pronoun { "Ele/Dele" }
    gender { "Masculino" }
    birth { "2000-01-01" }
    profile_picture { Rack::Test::UploadedFile.new('spec/fixtures/puts.png', 'image/png') }
  end
end
