require 'rails_helper'

describe 'User sees participant list' do
  it 'with success' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
    participants = [
      build(:participant, name: 'João'),
      build(:participant, name: 'Pedro'),
      build(:participant, name: 'Jeremias')
    ]
    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:participants).and_return(participants)

    login_as user, scope: :user
    visit event_path(event.id)

    within '#participant_list' do
      expect(page).to have_content 'João'
      expect(page).to have_content 'Pedro'
      expect(page).to have_content 'Jeremias'
    end
  end

  it 'and not found participants' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
            start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
            event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
    participants = []
    allow(Event).to receive(:find).and_return(event)
    allow(event).to receive(:participants).and_return(participants)

    login_as user, scope: :user
    visit event_path(event.id)

    within '#participant_list' do
      expect(page).to have_content 'Não foram localizados Participantes até o momento'
    end
  end
end
