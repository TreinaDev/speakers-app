require 'rails_helper'

describe 'User view curriculum task details', type: :system do
  it 'with success' do
    user = create(:user)
    create(:profile, user: user)
    event =  [ build(:event, name: 'Ruby on Rails') ]
    schedule1 = Schedule.new(date: "2025-02-15")
    schedule_item1 = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    schedules = [
      {
        schedule: schedule1,
        schedule_items: [ schedule_item1 ]
      }
    ]
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item1.code)
    content = create(:event_content, user: user, title: 'Conteúdo Rails')
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício', certificate_requirement: :optional)
    create(:curriculum_task_content, curriculum_task: task, curriculum_content: curriculum_content)
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item1)

    login_as user, scope: :user
    visit root_path
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'
    click_on 'Exercício Rails'

    expect(page).to have_content 'Exercício Rails'
    expect(page).to have_content 'Seu primeiro exercício'
    expect(page).to have_content 'Opcional'
    expect(page).to have_content 'Conteúdo Rails'
  end

  it 'and have contents attached' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    create(:profile, user: user)
    content = create(:event_content, user: user, title: 'Conteúdo Rails')
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício', certificate_requirement: :optional)
    create(:curriculum_task_content, curriculum_task: task, curriculum_content: curriculum_content)


    login_as user, scope: :user
    visit curriculum_curriculum_task_path(curriculum, task)

    expect(page).to have_content 'Exercício Rails'
    expect(page).to have_content 'Seu primeiro exercício'
    expect(page).to have_content 'Opcional'
    expect(page).to have_content 'Conteúdo Rails'
  end

  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício', certificate_requirement: :optional)

    visit curriculum_curriculum_task_path(curriculum, task)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'and must be the curriculum task owner' do
    user = create(:user)
    second_user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    create(:profile, user: second_user)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício', certificate_requirement: :optional)

    login_as second_user
    visit curriculum_curriculum_task_path(curriculum, task)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Conteúdo indisponível!'
  end

  it 'and go back to previous page' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    create(:profile, user: user)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício', certificate_requirement: :optional)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user
    visit curriculum_curriculum_task_path(curriculum, task)
    click_on 'VOLTAR'

    expect(current_path).to eq schedule_item_path(schedule_item.code)
  end

  it 'and curriculum task doesnt exists' do
    user = create(:user)
    create(:profile, user: user)
    schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.id)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user
    visit curriculum_curriculum_task_path(curriculum, 'ABCDE')

    expect(current_path).to eq schedule_item_path(schedule_item.id)
    expect(page).to have_content 'Conteúdo indisponível!'
  end
end
