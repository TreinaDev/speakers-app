require 'rails_helper'

RSpec.describe SocialNetwork, type: :model do
  context 'validations' do
    it { validate_presence_of(:url) }
    it { should validate_presence_of(:social_network_type) }
    it { should belong_to(:profile) }
  end
end
