require 'rails_helper'

describe 'User sees schedule item participants list', type: :system, js: true do
  it 'with success' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    allow(Event).to receive(:find).and_return(event)
    schedule_item = build(:schedule_item, code: '1234ABCD', name: 'Palestra Ruby')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    participant_2 = build(:participant, name: 'Cláudia', code: 'ABCD5678')
    participant_1 = build(:participant, name: 'João', code: 'ABCD1234')
    allow(Participant).to receive(:find).with(participant_code: 'ABCD1234').and_return(participant_1)
    create(:participant_record, user: user, schedule_item_code: '1234ABCD', participant_code: 'ABCD1234')
    allow(Participant).to receive(:find).with(participant_code: 'ABCD5678').and_return(participant_2)
    create(:participant_record, user: user, schedule_item_code: '1234ABCD', participant_code: 'ABCD5678')

    login_as user
    visit schedule_item_path(schedule_item.code)
    expect(page).to have_content 'Lista de Participantes'
    expect(page).not_to have_selector('#participant_list', visible: true)
    click_on 'Lista de Participantes'
    expect(page).to have_selector('#participant_list', visible: true)

    within '#participant_list' do
      expect(page).to have_content 'João'
      expect(page).to have_content 'Cláudia'
    end
  end

  it 'and there are no participants' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    event = build(:event, name: 'Ruby on Rails')
    allow(Event).to receive(:find).and_return(event)
    schedule_item = build(:schedule_item, code: '1234ABCD', name: 'Palestra Ruby')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user
    visit schedule_item_path(schedule_item.code)
    expect(page).to have_content 'Lista de Participantes'
    expect(page).not_to have_selector('#participant_list', visible: true)
    click_on 'Lista de Participantes'
    expect(page).to have_selector('#participant_list', visible: true)

    within '#participant_list' do
      expect(page).to have_content 'Não foram localizados Participantes até o momento'
    end
  end
end
