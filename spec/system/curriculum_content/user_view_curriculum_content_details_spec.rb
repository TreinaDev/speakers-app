require 'rails_helper'

describe 'User access curriculum content details', type: :system do
  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    create(:profile, user: user)
    content = user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)

    visit curriculum_curriculum_content_path(curriculum, curriculum_content)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'with success' do
    user = create(:user)
    create(:profile, user: user)
    event =  [ build(:event, name: 'Ruby on Rails') ]
    image_1 = fixture_file_upload(Rails.root.join('spec/fixtures/capi.png'))
    image_2 = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
    content = user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD', files: [ image_1, image_2 ])

    schedule1 = Schedule.new(date: "2025-02-15")
    schedule_item1 = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    schedules = [
      {
        schedule: schedule1,
        schedule_items: [ schedule_item1 ]
      }
    ]
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item1.code)
    create(:curriculum_content, curriculum: curriculum, event_content: content)

    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item1)

    login_as user, scope: :user
    visit root_path
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'
    click_on 'Arquivos TDD'

    expect(page).to have_content 'Arquivos TDD'
    expect(page).to have_content 'Apresentação sobre TDD'
    expect(page).to have_css("img[src*='capi.png']")
    expect(page).to have_css("img[src*='puts.png']")
  end

  it 'and must be the curriculum content owner' do
    first_user = create(:user)
    second_user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    create(:profile, user: second_user)
    content = first_user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD')
    curriculum = create(:curriculum, user: first_user, schedule_item_code: schedule_item.code)
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)

    login_as second_user
    visit curriculum_curriculum_content_path(curriculum, curriculum_content)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Conteúdo indisponível!'
  end

  it 'and go back to previous page' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    create(:profile, user: user)
    content = user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user
    visit curriculum_curriculum_content_path(curriculum, curriculum_content)
    click_on 'VOLTAR'

    expect(current_path).to eq schedule_item_path(schedule_item.code)
  end

  it 'and curriculum content doesnt exists' do
    user = create(:user)
    create(:profile, user: user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user
    visit curriculum_curriculum_content_path(curriculum, 'ABCDE')

    expect(current_path).to eq schedule_item_path(schedule_item.code)
    expect(page).to have_content 'Conteúdo indisponível!'
  end
end
