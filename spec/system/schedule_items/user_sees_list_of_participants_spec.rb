require 'rails_helper'

describe 'User sees list of participants' do
  it 'and must be authenticated' do
    visit schedule_item_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

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
    participants = [ build(:participant, name: 'João'), build(:participant, name: 'Lucas'), build(:participant, name: 'Thiago') ]
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)
    allow(schedule_items.first).to receive(:participants).and_return(participants)

    login_as user, scope: :user
    visit root_path
    click_on 'Dev week'
    click_on 'Entrevista com João'

    expect(page).to have_content 'Lista de Participantes'
    expect(page).to have_content 'João'
    expect(page).to have_content 'Lucas'
    expect(page).to have_content 'Thiago'
  end

  it 'does not locate participants' do
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
    participants = []
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)
    allow(schedule_items.first).to receive(:participants).and_return(participants)

    login_as user, scope: :user
    visit root_path
    click_on 'Dev week'
    click_on 'Entrevista com João'

    expect(page).to have_content 'Não foram localizados Participantes até o momento'
  end
end
