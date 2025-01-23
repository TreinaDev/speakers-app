require 'rails_helper'

describe 'User register a profile', type: :request do
  it 'for the second time' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    params = { title: 'Ruby para iniciantes', about_me: 'Um guia para programadores felizes.' }

    login_as user
    post profiles_path(params: { profile: params })

    expect(response).to redirect_to events_path
    expect(Profile.count).to eq(1)
    expect(flash[:alert]).to eq('Só é possível cadastrar um perfil.')
  end
end
