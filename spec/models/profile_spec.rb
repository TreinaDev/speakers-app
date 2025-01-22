require 'rails_helper'

RSpec.describe Profile, type: :model do
  context 'validations' do
    it { validate_presence_of(:title) }
    it { should validate_presence_of(:about_me) }
    it { should have_one_attached(:profile_picture) }
    it { should belong_to(:user) }
    it { should have_many(:social_networks) }
  end
end
