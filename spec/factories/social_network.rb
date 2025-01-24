FactoryBot.define do
  factory :social_network do
    url { "www.youtube.com" }
    social_network_type { 1 }
    profile
  end
end
