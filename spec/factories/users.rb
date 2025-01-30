FactoryBot.define do
  factory :user do
    first_name { 'João' }
    last_name { 'Campus' }
    email { generate :email }
    password { '123456' }
    token { SecureRandom.alphanumeric(8).upcase }
  end

  before(:create) do
    User.skip_callback(:validation, :before, :api_auth_user)
  end

  after(:create) do
    User.set_callback(:validation, :before, :api_auth_user)
  end
end
