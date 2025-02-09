FactoryBot.define do
  factory :user do
    first_name { "João" }
    last_name  { "Campus" }
    email      { Faker::Internet.email }
    password   { "123456" }
    token      { SecureRandom.hex(10) }

    transient do
      skip_api_auth { true }
    end

    before(:create) do |user, evaluator|
      if evaluator.skip_api_auth
        user.class.skip_callback(:validation, :before, :api_auth_user)
      end
    end

    after(:create) do |user, evaluator|
      if evaluator.skip_api_auth
        user.class.set_callback(:validation, :before, :api_auth_user)
      end
    end
  end
end
