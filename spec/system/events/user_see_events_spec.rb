require 'rails_helper'

describe 'user visit home and see list of events', type: :system do
  it 'is redirected to list of events page' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    create(:profile, user: user)

    login_as user, scope: :user
    visit root_path

    expect(current_path).to eq events_path
    expect(page).to have_content 'Meus Eventos'
  end

  it 'with success' do
    events = []
    2.times do |n|
      events << build(:event, name: "Event#{ n + 1}", start_date: '2025-02-01')
    end

    allow(Event).to receive(:all).and_return(events)
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    create(:profile, user: user)

    login_as user, scope: :user
    visit events_path

    expect(page).to have_content 'Meus Eventos'
    expect(page).to have_content('Event1')
    expect(page).to have_content('Event2')
    within "##{ events.first.code }" do
      expect(page).to have_css ".event__card-date-day", text: '01'
      expect(page).to have_css ".event__card-date-month", text: 'FEVEREIRO'
      expect(page).to have_css ".event__card-date-year", text: '2025'
    end
    within "##{ events.last.code }" do
      expect(page).to have_css ".event__card-date-day", text: '01'
      expect(page).to have_css ".event__card-date-month", text: 'FEVEREIRO'
      expect(page).to have_css ".event__card-date-year", text: '2025'
    end
  end

  it 'and dont exists events for him' do
    allow(Event).to receive(:all).and_return({})
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    create(:profile, user: user)

    login_as user, scope: :user
    visit events_path

    expect(page).to have_content 'Meus Eventos'
    expect(page).to have_content('Não existe nenhum evento ao qual você faça parte. Se você acha que isso é um erro, entre em contato com algum organizador.')
  end

  it 'and cannot visit event page if not authenticated' do
    visit events_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
