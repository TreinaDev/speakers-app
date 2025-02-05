require 'rails_helper'

describe 'Show Profile Event pagination', js: :true do
  it 'should advance the page when clicking next' do
    Event.delete_all
    events = build_list(:event, 16)
    allow(Event).to receive(:all).and_return(events)
    user = create(:user)
    profile = create(:profile, user: user)

    login_as user, scope: :user
    visit profile_path(profile.username)
    expect(page).to have_selector('.event__card', count: 15)
    click_on 'Próxima'
    expect(page).to have_selector('.event__card', count: 1)
  end

  it 'should advance the last page when clicking last' do
    Event.delete_all
    events = build_list(:event, 31)
    allow(Event).to receive(:all).and_return(events)
    user = create(:user)
    profile = create(:profile, user: user)

    login_as user, scope: :user
    visit profile_path(profile.username)
    expect(page).to have_selector('.event__card', count: 15)
    click_on 'Última'
    expect(page).to have_selector('.event__card', count: 1)
  end

  it 'should return a page when clicking previous' do
    Event.delete_all
    events = build_list(:event, 16)
    allow(Event).to receive(:all).and_return(events)
    user = create(:user)
    profile = create(:profile, user: user)

    login_as user, scope: :user
    visit profile_path(profile.username)
    expect(page).to have_selector('.event__card', count: 15)
    click_on 'Próxima'
    expect(page).to have_selector('.event__card', count: 1)
    click_on 'Anterior'
    expect(page).to have_selector('.event__card', count: 15)
  end

  it 'should advance the first page when clicking first' do
    Event.delete_all
    events = build_list(:event, 31)
    allow(Event).to receive(:all).and_return(events)
    user = create(:user)
    profile = create(:profile, user: user)

    login_as user, scope: :user
    visit profile_path(profile.username)
    expect(page).to have_selector('.event__card', count: 15)
    click_on 'Última'
    expect(page).to have_selector('.event__card', count: 1)
    click_on 'Primeira'
    expect(page).to have_selector('.event__card', count: 15)
  end

  it 'should advance the number page when clicking number' do
    Event.delete_all
    events = build_list(:event, 31)
    allow(Event).to receive(:all).and_return(events)
    user = create(:user)
    profile = create(:profile, user: user)

    login_as user, scope: :user
    visit profile_path(profile.username)
    expect(page).to have_selector('.event__card', count: 15)
    find('#page_2 a', text: '2').click
    expect(page).to have_selector('.event__card', count: 15, wait: 5)
    find('#page_3 a', text: '3').click
    expect(page).to have_selector('.event__card', count: 1, wait: 5)
  end
end
