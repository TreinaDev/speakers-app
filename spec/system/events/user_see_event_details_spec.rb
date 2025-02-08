require 'rails_helper'

describe 'User see event details', type: :system do
  it 'with success' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    create(:profile, user: user)
    events = [
      build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
      start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
      event_type: 'Presencial', address: 'Juiz de Fora', participants_limit: 100, status: 'published')
    ]
    20.times do |n|
      events << build(:event, name: "Event #{n}")
    end
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:find).and_return(events.first)

    login_as user, scope: :user
    visit root_path
    click_on 'Em breve'
    click_on 'Ruby on Rails'

    start_date = 7.days.from_now.strftime('%d/%m/%Y')
    end_date = 14.days.from_now.strftime('%d/%m/%Y')
    expect(page).to have_content 'Ruby on Rails'
    expect(page).to have_content 'Introdução ao Rails com TDD'
    expect(page).to have_content 'Localização: Juiz de Fora'
    expect(page).to have_content "Data de início: #{ start_date }"
    expect(page).to have_content "Encerramento: #{ end_date }"
    expect(page).to have_content 'www.meuevento.com/eventos/Ruby-on-Rails'
  end

  it 'and sees your schedules items' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', address: 'Juiz de Fora', participants_limit: 100, status: 'Publicado')
    schedule1 = Schedule.new(date: "2025-02-15")
    schedule_items =
      [ build(:schedule_item, name: 'Ruby on Rails', description: 'Introdução a programação', start_time: '11:00', end_time: '12:00'),
        build(:schedule_item, name: "TDD e introdução a API's", description: 'Desvolvimento Web', start_time: '10:00', end_time: '15:00'),
        build(:schedule_item, name: 'Python', description: 'Aprendizado de Máquina', start_time: '09:00', end_time: '16:00') ]
    schedules = [
      {
        schedule: schedule1,
        schedule_items: schedule_items
      }
    ]
    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:schedule_items).and_return(schedules)

    login_as user, scope: :user
    visit event_path(event.code)

    expect(page).to have_content '11:00 - 12:00'
    expect(page).to have_content '10:00 - 15:00'
    expect(page).to have_content '09:00 - 16:00'
  end

  it 'and should see a message when doesnt have schedule items' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', address: 'Juiz de Fora', participants_limit: 100, status: 'Publicado')

    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:schedule_items).and_return([])

    login_as user, scope: :user
    visit event_path(event.code)

    expect(page).to have_content 'Você não possui agendas disponíveis para esse evento. Se você acha que isso é um erro, entre em contato com o organizador.'
  end


  it 'and event doesnt exists' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    create(:profile, user: user)
    instance_double(Faraday::Response, success?: false)
    allow(Event).to receive(:find).and_return(nil)

    login_as user, scope: :user
    visit event_path(100)

    expect(page).to have_content 'Página indisponível'
    expect(current_path).to eq events_path
  end

  it 'and must be authenticated' do
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD')
    allow(Event).to receive(:find).and_return(event.code)

    visit event_path(event.code)

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_user_session_path
  end
end
