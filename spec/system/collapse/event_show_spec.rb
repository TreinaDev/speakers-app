require 'rails_helper'

describe 'Event show', js: :true do
  it 'should expanded event details when click in button' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'user1@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
      start_date: '2025-02-08', end_date: '2025-02-09', url: 'www.meuevento.com/eventos/Ruby-on-Rails',
      event_type: 'Presencial', address: 'Juiz de Fora', participants_limit: 100, status: 'published')

    allow(Event).to receive(:find).and_return(event)

    login_as user, scope: :user
    visit event_path(event.code)
    expect(page).not_to have_css 'span', text: 'Introdução ao Rails com TDD'
    click_on 'Mostrar mais'
    expect(page).to have_css 'span', text: 'Introdução ao Rails com TDD'
  end
end
