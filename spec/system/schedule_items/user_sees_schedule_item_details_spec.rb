require 'rails_helper'

describe 'User sees schedule item details', type: :system do
  it 'with success' do
    user = create(:user, first_name: 'João', email: 'joão@email.com')
    event = [ build(:event, name: 'Dev week') ]
    schedule1 = Schedule.new(date: "2025-02-15")
    schedule_items =
      [ build(:schedule_item, name: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD', start_time: '11:00', end_time: '12:00'),
        build(:schedule_item, name: "TDD e introdução a API's", description: 'Desvolvimento Web', start_time: '10:00', end_time: '15:00'),
        build(:schedule_item, name: 'Python', description: 'Aprendizado de Máquina', start_time: '09:00', end_time: '16:00') ]
    schedules = [
      {
        schedule: schedule1,
        schedule_items: schedule_items
      }
    ]
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)

    login_as user, scope: :user
    visit root_path
    click_on 'Dev week'
    click_on 'Entrevista com João'

    expect(page).to have_content 'Entrevista com João'
    expect(page).to have_content 'Aprenda sobre RoR e TDD'
    expect(page).to have_content "Início: 11:00"
    expect(page).to have_content "Encerramento: 12:00"
    expect(page).not_to have_content 'Agenda 1'
    expect(page).not_to have_content 'Agenda 2'
    expect(page).not_to have_content 'Agenda 3'
  end

  it 'and the schedule item doesnt exists' do
    user = create(:user, first_name: 'João', email: 'joão@email.com')
    allow(ScheduleItem).to receive(:find).and_return(nil)

    login_as user, scope: :user
    visit schedule_item_path(999999)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Essa Programação não existe'
  end

  it 'and must be authenticated' do
    visit schedule_item_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
