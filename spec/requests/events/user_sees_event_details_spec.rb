require 'rails_helper'

describe 'User sees Event details', type: :request do
  it 'must be authenticated' do
    event = build(:event, code: 'ABC123', name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', address: 'Juiz de Fora', participants_limit: 100, status: 'Publicado')
    allow(Event).to receive(:find).and_return(event)

    get event_path(event.code)

    expect(response).to redirect_to new_user_session_path
  end

  it 'and event doesnt exists' do
    user = create(:user)
    response = instance_double(Faraday::Response, success?: false)
    allow(Faraday).to receive(:get).and_return(response)

    login_as user, scope: :user
    get event_path(99999)

    expect(response).to redirect_to events_path
  end
end
