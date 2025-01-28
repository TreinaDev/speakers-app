require 'rails_helper'

describe 'A curriculum is generated for user schedule item', type: :system do
  it 'and user must be authenticated' do
    schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')

    visit schedule_item_path(schedule_item)

    expect(current_path).to eq new_user_session_path
    expect(Curriculum.count).to eq 0
  end

  it 'when access your schedule item page for the first time' do
    user = create(:user, id: 99)
    event =  [ build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
                  start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
                  event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado') ]
    schedule_items = [ build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD') ]

    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedule_items)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)

    login_as user, scope: :user
    visit root_path
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'

    curriculum = Curriculum.find_by(schedule_item_code: '99', user_id: 99)
    expect(curriculum.schedule_item_code).to eq '99'
    expect(curriculum.user_id). to eq 99
  end

  it 'and should not create curriculum when schedule item does not exist' do
    user = create(:user)

    login_as user, scope: :user
    visit schedule_item_path(9999)

    expect(current_path).to eq events_path
    expect(Curriculum.count).to eq 0
  end
end
