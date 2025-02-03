require 'rails_helper'

describe 'User sees participant list', type: :system, js: true do
  it 'with success' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    participants = [
      build(:participant, name: 'João'),
      build(:participant, name: 'Pedro'),
      build(:participant, name: 'Jeremias')
    ]
    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:participants).and_return(participants)

    login_as user, scope: :user
    visit event_path(event.code)
    expect(page).not_to have_selector('#participant_list', visible: true)
    click_on 'Lista de Participantes'
    expect(page).to have_selector('#participant_list', visible: true)

    within '#participant_list' do
      expect(page).to have_content 'Lista de Participantes'
      expect(page).to have_content 'Número de Participantes: 3'
      expect(page).to have_content 'João'
      expect(page).to have_content 'Pedro'
      expect(page).to have_content 'Jeremias'
    end
  end

  it 'and not found participants' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    participants = []
    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:participants).and_return(participants)

    login_as user, scope: :user
    visit event_path(event.code)
    expect(page).not_to have_selector('#participant_list', visible: true)
    click_on 'Lista de Participantes'
    expect(page).to have_selector('#participant_list', visible: true)

    within '#participant_list' do
      expect(page).to have_content 'Não foram localizados Participantes até o momento'
    end
  end
end
