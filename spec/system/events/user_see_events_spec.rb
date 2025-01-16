require 'rails_helper'

describe 'user visit home and see list of events', type: :system do
  it 'with success' do
    events = [ Event.new(id: 1,
                          name: 'Event1',
                          url: '',
                          description: 'Event1 description',
                          start_date: '14-01-2025',
                          end_date: '16-01-2025',
                          event_type: 'in-person',
                          location: 'Palhoça',
                          participant_limit: 20,
                          status: 'published'),
                Event.new(id: 2,
                          name: 'Event2',
                          url: '',
                          description: 'Event2 description',
                          start_date: '15-01-2025',
                          end_date: '17-01-2025',
                          event_type: 'in-person',
                          location: 'Florianópolis',
                          participant_limit: 20,
                          status: 'draft') ]

    allow(Event).to receive(:all).and_return(events)
    user = User.create!(first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')

    login_as user, scope: :user
    visit root_path

    expect(page).to have_content 'Lista de Eventos'
    expect(page).to have_content('Event1')
    expect(page).to have_content('Event2')
    expect(page).to have_content('Event1 description')
    expect(page).to have_content('Event2 description')
    expect(page).to have_content('Data início: 14-01-2025')
    expect(page).to have_content('Data início: 15-01-2025')
  end

  it 'and dont exists events for him', type: :system do
    mock_events = double('Event')
    allow(Event).to receive(:all).and_return(mock_events)
    allow(mock_events).to receive(:presence).and_return({})
    user = User.create!(first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')

    login_as user, scope: :user
    visit root_path

    expect(page).to have_content 'Lista de Eventos'
    expect(page).to have_content('Não existe nenhum evento ao qual você faça parte. Se você acha que isso é um erro, entre em contato com algum organizador.')
  end

  it 'and cannot visit homepage if not authenticated',  type: :system do
    visit root_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
