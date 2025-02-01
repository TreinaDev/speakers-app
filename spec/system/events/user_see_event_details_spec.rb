require 'rails_helper'

describe 'User see event details', type: :system do
  it 'with success' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
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

  it 'but must be published' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    events = [
      build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
      start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
      event_type: 'Presencial', address: 'Juiz de Fora', participants_limit: 100, status: 'draft')
    ]
    20.times do |n|
      events << build(:event, name: "Event #{n}")
    end
    allow(Event).to receive(:all).and_return(events)

    login_as user, scope: :user
    visit root_path

    expect(page).to have_content 'Ruby on Rails'
    expect(page).not_to have_link "##{events.first.code}"
  end

  it 'and sees your schedules items' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', location: 'Juiz de Fora', participants_limit: 100, status: 'Publicado')
    schedule_items =
      [ build(:schedule_item, title: 'Ruby on Rails', description: 'Introdução a programação'),
        build(:schedule_item, title: "TDD e introdução a API's", description: 'Desvolvimento Web'),
        build(:schedule_item, title: 'Python', description: 'Aprendizado de Máquina') ]

    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:schedule_items).and_return(schedule_items)

    login_as user, scope: :user
    visit event_path(event.code)

    expect(page).to have_content 'Ruby on Rails'
    expect(page).to have_content "TDD e introdução a API's"
    expect(page).to have_content 'Python'
  end

  it 'and should see a message when doesnt have schedule items' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', location: 'Juiz de Fora', participants_limit: 100, status: 'Publicado')

    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:schedule_items).and_return([])

    login_as user, scope: :user
    visit event_path(event.code)

    expect(page).to have_content 'Você não possui agendas disponíveis para esse evento. Se você acha que isso é um erro, entre em contato com o organizador.'
  end


  it 'and event doesnt exists' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    response = instance_double(Faraday::Response, success?: false)
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
