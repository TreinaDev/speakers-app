require 'rails_helper'

describe 'User sees schedule item details', type: :system do
  it 'with success' do
    user = create(:user, first_name: 'João', email: 'joão@email.com')
    event = [ build(:event, name: 'Dev week') ]
    seven_days = 7.days.from_now
    schedule_items = [ build(:schedule_item, title: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD', speaker_email: user.email, length: 100, start_time: seven_days) ]
    3.times do |n|
      schedule_items << build(:schedule_item, title: "Agenda #{ n + 1 }")
    end
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedule_items)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)

    login_as user, scope: :user
    visit root_path
    click_on 'Dev week'
    click_on 'Entrevista com João'

    expect(page).to have_content 'Entrevista com João'
    expect(page).to have_content 'Aprenda sobre RoR e TDD'
    expect(page).to have_content 'Número estimado de participantes: 100', normalize_ws: true
    expect(page).to have_content "Data/Hora: #{I18n.l(seven_days, format: :brazilian)}", normalize_ws: true
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
