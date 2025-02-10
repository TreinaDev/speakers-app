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
                         build(:feedback_schedule_item, user: 'Anônimo', title: 'Podia ser melhor', comment: 'Faltou café'),
                         build(:feedback_schedule_item, user: 'Joaquim', title: 'Parabéns você foi selecionado', comment: 'Esta mensagem foi marcada como Spam') ]
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
        expect(page).to have_content 'Joaquim'
        expect(page).to have_content 'Parabéns você foi selecionado'
        expect(page).to have_content 'Esta mensagem foi marcada como Spam'
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
  end
end
