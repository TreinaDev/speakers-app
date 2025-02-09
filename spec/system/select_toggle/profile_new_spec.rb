require 'rails_helper'

describe 'Profile new', js: true do
  it 'text fields must display none' do
    user = create(:user, first_name: 'João')
    service = ExternalEventApi::UserFindEmailService
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return("ABCD1234")

    login_as user
    visit new_profile_path
    select('Ele/Dele', from: 'Pronome')
    select('Masculino', from: 'Gênero')

    expect(page).not_to have_selector('#profile_other_pronoun', visible: true)
    expect(page).not_to have_selector('#profile_other_gender', visible: true)
  end
end
