require 'rails_helper'

describe 'User can view feedback for an schedule item', type: :system, js: true do
  context 'from the schedule item details page' do
    it 'with success' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      create(:profile, user: user)
      event = build(:event, name: 'Ruby on Rails')
      allow(Event).to receive(:find).and_return(event)
      schedule_item = build(:schedule_item)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      schedule_item_feedbacks = [ build(:feedback_schedule_item, user: 'João', title: 'Muito bom!', comment: 'Gostei muito'),
                         build(:feedback_schedule_item, user: 'Anônimo', title: 'Podia ser melhor', comment: 'Faltou café') ]
      allow(FeedbackScheduleItem).to receive(:schedule).with(schedule_item_code: schedule_item.code).and_return(schedule_item_feedbacks)

      login_as user, scope: :user
      visit schedule_item_path(schedule_item.code)
      expect(page).not_to have_selector('#feedbacks', visible: true)
      click_on 'Feedbacks da Palestra'
      expect(page).to have_selector('#feedbacks', visible: true)

      within '#feedbacks' do
        expect(page).to have_content 'João'
        expect(page).to have_content 'Muito bom!'
        expect(page).to have_content 'Gostei muito'
        expect(page).to have_content 'Anônimo'
        expect(page).to have_content 'Podia ser melhor'
        expect(page).to have_content 'Faltou café'
      end
    end

    it 'and not found feedbacks for event' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      create(:profile, user: user)
      event = build(:event, name: 'Ruby on Rails')
      allow(Event).to receive(:find).and_return(event)
      schedule_item = build(:schedule_item)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(FeedbackScheduleItem).to receive(:schedule).with(schedule_item_code: schedule_item.code).and_return([])

      login_as user, scope: :user
      visit schedule_item_path(schedule_item.code)
      expect(page).not_to have_selector('#feedbacks', visible: true)
      click_on 'Feedbacks da Palestra'
      expect(page).to have_selector('#feedbacks', visible: true)

      within '#feedbacks' do
        expect(page).to have_content 'Nenhum feedback disponível para esta agenda'
      end
    end

    it 'and provides a replica of feedback' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      create(:profile, user: user)
      event = build(:event, name: 'Ruby on Rails')
      allow(Event).to receive(:find).and_return(event)
      schedule_item = build(:schedule_item)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      schedule_item_feedbacks = [ build(:feedback_schedule_item, user: 'João', title: 'Muito bom!', comment: 'Gostei muito'),
                         build(:feedback_schedule_item, user: 'Anônimo', title: 'Podia ser melhor', comment: 'Faltou café'),
                         build(:feedback_schedule_item, user: 'Joaquim', title: 'Parabéns você foi selecionado', comment: 'Esta mensagem foi marcada como Spam') ]
      allow(FeedbackScheduleItem).to receive(:schedule).with(schedule_item_code: schedule_item.code).and_return(schedule_item_feedbacks)
      allow(FeedbackScheduleItem).to receive(:post_answer).and_return(true)

      login_as user, scope: :user
      visit schedule_item_path(schedule_item.code)
      expect(page).not_to have_selector('#feedbacks', visible: true)
      click_on 'Feedbacks da Palestra'
      expect(page).to have_selector('#feedbacks', visible: true)
      
      within "#feedback_1" do
        fill_in 'Resposta', with: 'Que pena!'
        click_on 'Enviar Resposta'
      end

      expect(page).to have_content 'Resposta enviada com sucesso!'
    end

    it 'answer must be present' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      create(:profile, user: user)
      event = build(:event, name: 'Ruby on Rails')
      allow(Event).to receive(:find).and_return(event)
      schedule_item = build(:schedule_item)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      schedule_item_feedbacks = [ build(:feedback_schedule_item, user: 'João', title: 'Muito bom!', comment: 'Gostei muito'),
                         build(:feedback_schedule_item, user: 'Anônimo', title: 'Podia ser melhor', comment: 'Faltou café'),
                         build(:feedback_schedule_item, user: 'Joaquim', title: 'Parabéns você foi selecionado', comment: 'Esta mensagem foi marcada como Spam') ]
      allow(FeedbackScheduleItem).to receive(:schedule).with(schedule_item_code: schedule_item.code).and_return(schedule_item_feedbacks)
      allow(FeedbackScheduleItem).to receive(:post_answer).and_return(false)

      login_as user, scope: :user
      visit schedule_item_path(schedule_item.code)
      expect(page).not_to have_selector('#feedbacks', visible: true)
      click_on 'Feedbacks da Palestra'
      expect(page).to have_selector('#feedbacks', visible: true)
      
      within "#feedback_1" do
        fill_in 'Resposta', with: ''
        click_on 'Enviar Resposta'
      end

      expect(page).to have_content 'Não foi possível adicionar sua resposta!'
    end
  end
end
