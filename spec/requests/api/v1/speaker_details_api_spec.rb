require 'rails_helper'

describe 'Speaker Details API' do
  context 'api/v1/speaker/:email' do
    it 'and return success' do
      user = create(:user, email: "joao@email.com", first_name: 'João', last_name: 'Campus')
      image = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
      profile = create(:profile, title: 'Instrutor', about_me: 'Olá, meu nome é José e eu sou um instrutor de Ruby on Rails',
                       user: user, profile_picture: image, pronoun: 'Ele/Dele', city: 'Florianópolis', birth: '1999-01-02', gender: 'Masculino')

      get api_v1_speaker_path(user.email)

      json = JSON.parse(response.body)
      expect(response).to have_http_status :success
      expect(response.content_type).to include 'application/json'
      expect(json['speaker']['first_name']).to eq 'João'
      expect(json['speaker']['last_name']).to eq 'Campus'
      expect(json['speaker']['role']).to eq 'Instrutor'
      expect(json['speaker']['profile_image_url']).to include rails_blob_url(profile.profile_picture)
      expect(json['speaker']['profile_url']).to include url_for(profile.username)
    end

    it 'and not found' do
      get api_v1_speaker_path('something')

      json = JSON.parse(response.body)
      expect(response).to have_http_status :not_found
      expect(response.content_type).to include 'application/json'
      expect(json['error']).to eq 'Palestrante não encontrado!'
    end

    it 'and raise internal error' do
      user = create(:user, email: "joao@email.com", first_name: 'João', last_name: 'Campus')
      image = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
      create(:profile, title: 'Instrutor', about_me: 'Olá, meu nome é José e eu sou um instrutor de Ruby on Rails',
                       user: user, profile_picture: image, pronoun: 'Ele/Dele', city: 'Florianópolis', birth: '1999-01-02', gender: 'Masculino')

      allow(User).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get api_v1_speaker_path(user.email)

      json = JSON.parse(response.body)
      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :internal_server_error
      expect(json['error']).to eq 'Algo deu errado.'
    end
  end
end
