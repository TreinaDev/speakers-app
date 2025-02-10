require 'rails_helper'

RSpec.describe Profile, type: :model do
  context 'validations' do
    subject { create(:profile) }
    it { validate_presence_of(:title) }
    it { should validate_presence_of(:about_me) }
    it { should validate_presence_of(:pronoun) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:birth) }
    it { should validate_presence_of(:city) }
    it { should have_one_attached(:profile_picture) }
    it { should belong_to(:user) }
    it { should have_many(:social_networks) }
    it { should validate_uniqueness_of(:username) }

    context '.generate_unique_username' do
      it 'with success' do
        user = create(:user, first_name: 'João', last_name: 'Almeida')
        profile = create(:profile, user: user)

        expect(profile.username).to eq('joao_almeida')
      end

      it 'two users with the same name but different username' do
        user_1 = create(:user, first_name: 'João', last_name: 'Almeida', email: 'joãoGoiaba@email.com', password: '123456')
        user_2 = create(:user, first_name: 'João', last_name: 'Almeida', email: 'joãoalmeida@email.com', password: '654789')
        profile_1 = create(:profile, user: user_1)
        profile_2 = create(:profile, user: user_2)

        expect(profile_1.username).not_to eq(profile_2.username)
        expect(profile_1.username).to eq('joao_almeida')
        expect(profile_2.username).to eq('joao_almeida1')
      end
    end

    context '.validation_for_birth' do
      it 'with future date' do
        profile = build(:profile, birth: 1.days.from_now)

        expect(profile.valid?).to eq(false)
        expect(profile.errors[:birth_base].first).to include('Palestrante deve ter mais de 18 anos.')
      end

      it 'with date invalid' do
        profile = build(:profile, birth: 15.years.ago)

        expect(profile.valid?).to eq(false)
        expect(profile.errors[:birth_base].first).to include('Palestrante deve ter mais de 18 anos.')
      end

      it 'with success' do
        profile = build(:profile, birth: 18.years.ago)

        expect(profile.valid?).to eq(true)
      end
    end
  end
end
