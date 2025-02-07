require 'rails_helper'

describe 'Tab navigation in events show', js: true do
  it 'default tab is ongoing events' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    events = build_list(:event, 30)
    allow(Event).to receive(:all).and_return(events)

    login_as user, scope: :user
    visit events_path

    expect(page).to have_selector('#ongoing_events_list', visible: true)
    expect(page).not_to have_selector('#past_events_list', visible: true)
    expect(page).not_to have_selector('#past_events_list', visible: true)
  end

  it 'selected future events' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    events = build_list(:event, 30)
    allow(Event).to receive(:all).and_return(events)

    login_as user, scope: :user
    visit events_path
    click_on 'Em breve'

    expect(page).not_to have_selector('#ongoing_events_list', visible: true)
    expect(page).to have_selector('#future_events_list', visible: true)
    expect(page).not_to have_selector('#past_events_list', visible: true)
  end

  it 'selected past events' do
    user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
    create(:profile, user: user)
    events = build_list(:event, 30)
    allow(Event).to receive(:all).and_return(events)

    login_as user, scope: :user
    visit events_path
    click_on 'Finalizados'

    expect(page).not_to have_selector('#ongoing_events_list', visible: true)
    expect(page).not_to have_selector('#future_events_list', visible: true)
    expect(page).to have_selector('#past_events_list', visible: true)
  end
end
