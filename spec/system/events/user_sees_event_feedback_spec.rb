require 'rails_helper'

describe 'User can view feedback for an event' do
  context 'from the event details page' do
    it 'with success', js: true do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
              start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
              event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      allow(Event).to receive(:find).and_return(event)
      event_feedbacks = [ build(:feedback, name: 'João', title: 'Muito bom!', description: 'Gostei muito'),
                         build(:feedback, name: 'Anônimo', title: 'Podia ser melhor', description: 'Faltou café'),
                         build(:feedback, name: 'Joaquim', title: 'Parabéns você foi selecionado', description: 'Esta mensagem foi marcada como Spam') ]
      allow(Feedback).to receive(:event).with(event_id: event.id, speaker: user.email).and_return(event_feedbacks)

      login_as user, scope: :user
      visit event_path(event.id)
      expect(page).not_to have_selector('.modal', visible: true)
      click_on 'Feedbacks'
      expect(page).to have_selector('.modal', visible: true)

      within '#feedbacks' do
        expect(page).to have_content 'Usuário: João'
        expect(page).to have_content 'Muito bom!'
        expect(page).to have_content 'Gostei muito'
        expect(page).to have_content 'Usuário: Anônimo'
        expect(page).to have_content 'Podia ser melhor'
        expect(page).to have_content 'Faltou café'
        expect(page).to have_content 'Usuário: Joaquim'
        expect(page).to have_content 'Parabéns você foi selecionado'
        expect(page).to have_content 'Esta mensagem foi marcada como Spam'
      end
    end

    it 'closes the modal after opening', js: true do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails', description: 'Introduction to Rails with TDD',
        start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
        event_type: 'In-person', location: 'Juiz de Fora', participant_limit: 100, status: 'Published')
      allow(Event).to receive(:find).and_return(event)
      event_feedbacks = [ build(:feedback, name: 'João', title: 'Very good!', description: 'I liked it a lot'),
           build(:feedback, name: 'Anonymous', title: 'Could be better', description: 'No coffee'),
           build(:feedback, name: 'Joaquim', title: 'Congratulations, you were selected', description: 'This message was marked as Spam') ]
      allow(Feedback).to receive(:event).with(event_id: event.id, speaker: user.email).and_return(event_feedbacks)

      login_as user, scope: :user
      visit event_path(event.id)

      expect(page).not_to have_selector('.modal', visible: true)
      click_on 'Feedbacks'
      expect(page).to have_selector('.modal', visible: true)
      find('.close-btn').click
      expect(page).not_to have_selector('.modal', visible: true)
    end

    it 'and not found feedbacks for event' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
              start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
              event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      allow(Event).to receive(:find).and_return(event)
      allow(Feedback).to receive(:event).with(event_id: event.id, speaker: user.email).and_return([])

      login_as user, scope: :user
      visit event_path(event.id)

      within '#feedbacks' do
        expect(page).to have_content 'Nenhum Feedback disponível'
      end
    end
  end
end
