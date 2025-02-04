require 'rails_helper'

describe 'A curriculum is generated for user schedule item', type: :system do
  it 'and user must be authenticated' do
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')

    visit schedule_item_path(schedule_item.code)

    expect(current_path).to eq new_user_session_path
    expect(Curriculum.count).to eq 0
  end

  it 'when access your schedule item page for the first time' do
    user = create(:user, id: 99)
    event = [ build(:event, name: 'Ruby on Rails') ]
    schedule1 = Schedule.new(date: "2025-02-15")
    schedule_item1 = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    schedules = [
      {
        schedule: schedule1,
        schedule_items: [ schedule_item1 ]
      }
    ]
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item1)

    login_as user, scope: :user
    visit root_path
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'
    curriculum = Curriculum.find_by(schedule_item_code: 99, user_id: 99)

    expect(curriculum).not_to be_nil
    expect(curriculum.schedule_item_code).to eq '99'
    expect(curriculum.user_id).to eq 99
  end

  it 'and should not create curriculum when schedule item does not exist' do
    user = create(:user)

    login_as user, scope: :user
    visit schedule_item_path(9999)

    expect(current_path).to eq events_path
    expect(Curriculum.count).to eq 0
  end
end
