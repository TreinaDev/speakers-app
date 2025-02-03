require 'rails_helper'

describe 'User can view feedback for an event', type: :system, js: true do
  context 'from the event details page' do
    it 'with success' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      create(:profile, user: user)
      event = build(:event, name: 'Ruby on Rails')
      allow(Event).to receive(:find).and_return(event)
      event_feedbacks = [ build(:feedback, name: 'João', title: 'Muito bom!', description: 'Gostei muito'),
                         build(:feedback, name: 'Anônimo', title: 'Podia ser melhor', description: 'Faltou café'),
                         build(:feedback, name: 'Joaquim', title: 'Parabéns você foi selecionado', description: 'Esta mensagem foi marcada como Spam') ]
      allow(Feedback).to receive(:event).with(event_code: event.code, speaker: user.email).and_return(event_feedbacks)

      login_as user, scope: :user
      visit event_path(event.code)
      expect(page).not_to have_selector('#feedbacks', visible: true)
      click_on 'Feedbacks do Evento'
      expect(page).to have_selector('#feedbacks', visible: true)

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

    it 'and not found feedbacks for event' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      create(:profile, user: user)
      event = build(:event, name: 'Ruby on Rails')
      allow(Event).to receive(:find).and_return(event)
      allow(Feedback).to receive(:event).with(event_code: event.code, speaker: user.email).and_return([])

      login_as user, scope: :user
      visit event_path(event.code)
      expect(page).not_to have_selector('#feedbacks', visible: true)
      click_on 'Feedbacks do Evento'
      expect(page).to have_selector('#feedbacks', visible: true)

      within '#feedbacks' do
        expect(page).to have_content 'Nenhum Feedback disponível'
      end
    end
  end
end
