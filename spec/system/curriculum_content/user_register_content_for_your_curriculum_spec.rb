require 'rails_helper'

describe 'User register content for your schedule item curriculum', type: :system, js: true do
  it 'with success' do
    user = create(:user)
    event =  [ build(:event, name: 'Ruby on Rails') ]
    user.event_contents.create(title: 'Introdução', description: 'Apresentação')
    user.event_contents.create(title: 'Desenvolvimento', description: 'Lógica de Programação')
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
    click_on 'Adicionar conteúdo'
    select 'Desenvolvimento', from: 'Selecionar conteúdo'
    click_on 'Adicionar'

    expect(CurriculumContent.count).to eq 1
    expect(current_path).to eq schedule_item_path(schedule_item1.code)
    expect(page).to have_content 'Desenvolvimento'
  end

  it 'and must not show a event content already attached to the schedule item curriculum' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    first_content = user.event_contents.create(title: 'Introdução', description: 'Apresentação')
    user.event_contents.create(title: 'Desenvolvimento', description: 'Lógica de Programação')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    create(:curriculum_content, curriculum: curriculum, event_content: first_content)

    login_as user
    visit new_curriculum_curriculum_content_path(curriculum)

    expect(page).to have_no_select 'Selecionar conteúdo', with_options: [ 'Introdução' ]
    expect(page).to have_select 'Selecionar conteúdo', with_options: [ 'Desenvolvimento' ]
  end

  it 'and must display message when no event content is available' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)

    login_as user
    visit new_curriculum_curriculum_content_path(curriculum)

    expect(page).not_to have_field 'Conteúdos'
    expect(page).to have_content 'Não existem conteúdos disponíveis.'
    expect(page).to have_link 'Clique aqui para cadastrar um conteúdo'
  end

  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)

    visit new_curriculum_curriculum_content_path(curriculum)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and should redirect to events path when curriculum doesnt exists' do
    user = create(:user)

    login_as user
    visit new_curriculum_curriculum_content_path(9999)

    expect(page).to have_content 'Conteúdo indisponível'
    expect(current_path).to eq events_path
  end

  it 'and must be the curriculum owner' do
    first_user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: first_user, schedule_item_code: schedule_item.code)
    secont_user = create(:user)

    login_as secont_user
    visit new_curriculum_curriculum_content_path(curriculum)

    expect(page).to have_content 'Conteúdo indisponível'
    expect(current_path).to eq events_path
  end
end
