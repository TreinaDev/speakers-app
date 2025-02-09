require 'rails_helper'

RSpec.describe SocialNetwork, type: :model do
  context 'validations' do
    it { validate_presence_of(:url) }
    it { should validate_presence_of(:social_network_type) }
    it { should belong_to(:profile) }
  end

  context '.validate_url_type' do
    it 'with problem for youtube type' do
      social_network = build(:social_network, social_network_type: 1, url: 'you.com/algumcanal')

      expect(social_network.valid?).to eq(false)
      expect(social_network.errors.full_messages).to include('Url inválida para Youtube')
    end

    it 'with problem for x type' do
      social_network = build(:social_network, social_network_type: 2, url: 'twitterX.com/algumperfil')

      expect(social_network.valid?).to eq(false)
      expect(social_network.errors.full_messages).to include('Url inválida para X')
    end

    it 'with problem for GitHub type' do
      social_network = build(:social_network, social_network_type: 3, url: 'gitlab.com/algumperfil')

      expect(social_network.valid?).to eq(false)
      expect(social_network.errors.full_messages).to include('Url inválida para GitHub')
    end

    it 'with problem for Facebook type' do
      social_network = build(:social_network, social_network_type: 4, url: 'faceapp.com/algumperfil')

      expect(social_network.valid?).to eq(false)
      expect(social_network.errors.full_messages).to include('Url inválida para Facebook')
    end

    it 'with problem for a custom site' do
      social_network = build(:social_network, social_network_type: 0, url: 'algumtexto')

      expect(social_network.valid?).to eq(false)
      expect(social_network.errors.full_messages).to include('Url inválida para Meu Site')
    end
  end

  context 'valid_protocol' do
    it 'include protocol in url' do
      social_network = create(:social_network, social_network_type: 1, url: 'www.youtube.com/algumcanal')

      expect(social_network.url).to eq('https://www.youtube.com/algumcanal')
    end
  end
end
