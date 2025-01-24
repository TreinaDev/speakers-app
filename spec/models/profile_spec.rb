require 'rails_helper'

RSpec.describe Profile, type: :model do
  context 'validations' do
    subject { create(:profile) }
    it { validate_presence_of(:title) }
    it { should validate_presence_of(:about_me) }
    it { should have_one_attached(:profile_picture) }
    it { should belong_to(:user) }
    it { should have_many(:social_networks) }
    it { should validate_uniqueness_of(:username) }

    context '.generate_unique_username' do
      it 'two users with the same name but different username' do
        user_1 = create(:user, first_name: 'João', last_name: 'Almeida', email: 'joãoGoiaba@email.com', password: '123456')
        user_2 = create(:user, first_name: 'João', last_name: 'Almeida', email: 'joãoalmeida@email.com', password: '654789')
        profile_1 = create(:profile, user: user_1)
        profile_2 = create(:profile, user: user_2)

        expect(profile_1.username).not_to eq(profile_2.username)
      end
    end
  end
end
