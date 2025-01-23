FactoryBot.define do
  factory :profile do
    title { "Instrutor" }
    about_me { "Minha vida pessoal" }
    user
    profile_picture { Rack::Test::UploadedFile.new('spec/fixtures/puts.png', 'image/png') }
  end
end
