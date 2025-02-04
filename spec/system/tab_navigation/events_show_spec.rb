require 'rails_helper'

describe 'Tab navigation in events show', js: true do
  it 'schedule items should default tab' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    allow(Event).to receive(:find).and_return(event)

    login_as user, scope: :user
    visit event_path(event.code)

    expect(page).not_to have_selector('#feedbacks', visible: true)
    expect(page).not_to have_selector('#participant_list', visible: true)
    expect(page).to have_selector('#schedule_items', visible: true)
  end

  it 'selected feedback list' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    allow(Event).to receive(:find).and_return(event)

    login_as user, scope: :user
    visit event_path(event.code)
    click_on 'Feedbacks do Evento'

    expect(page).to have_selector('#feedbacks', visible: true)
    expect(page).not_to have_selector('#participant_list', visible: true)
    expect(page).not_to have_selector('#schedule_items', visible: true)
  end

  it 'selected participant list' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    allow(Event).to receive(:find).and_return(event)

    login_as user, scope: :user
    visit event_path(event.code)
    click_on 'Lista de Participantes'

    expect(page).not_to have_selector('#feedbacks', visible: true)
    expect(page).to have_selector('#participant_list', visible: true)
    expect(page).not_to have_selector('#schedule_items', visible: true)
  end
end
