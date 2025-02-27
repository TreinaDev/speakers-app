require 'rails_helper'

describe 'User register task for your schedule item curriculum', type: :system, js: true do
  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)

    visit new_curriculum_curriculum_task_path(curriculum)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

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
    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedules)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item1)

    login_as user, scope: :user
    visit root_path
    click_on 'Em breve'
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'
    click_on 'Adicionar tarefa'
    fill_in 'Título', with: 'Tarefa 01'
    fill_in 'Descrição', with: 'Lorem ipsum'
    choose 'Obrigatória'
    click_on 'Adicionar'

    expect(CurriculumTask.count).to eq 1
    expect(current_path).to eq schedule_item_path(schedule_item1.code)
    expect(page).to have_content 'Tarefa adicionada com sucesso!'
    expect(page).to have_content 'Tarefa 01'
  end

  it 'and attach an content to task' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    create(:profile, user: user)
    first_content = create(:event_content, user: user, title: 'Workshop Stimulus')
    second_content = create(:event_content, user: user, title: 'Ruby para Iniciantes')
    create(:curriculum_content, curriculum: curriculum, event_content: first_content)
    create(:curriculum_content, curriculum: curriculum, event_content: second_content)

    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user
    visit schedule_item_path(schedule_item.code)
    click_on 'Adicionar tarefa'
    fill_in 'Título', with: 'Tarefa 01'
    fill_in 'Descrição', with: 'Lorem ipsum'
    choose 'Obrigatória'
    check 'Workshop Stimulus'
    check 'Ruby para Iniciantes'
    click_on 'Adicionar'

    expect(CurriculumTask.count).to eq 1
    expect(CurriculumTaskContent.count).to eq 2
    expect(current_path).to eq schedule_item_path(schedule_item.code)
    expect(page).to have_content 'Tarefa adicionada com sucesso!'
    expect(page).to have_content 'Tarefa 01'
  end

  it 'and must fill all required fields' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    create(:profile, user: user)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user, scope: :user
    visit schedule_item_path(schedule_item.code)
    click_on 'Adicionar tarefa'
    fill_in 'Título', with: ''
    fill_in 'Descrição', with: ''
    click_on 'Adicionar'

    expect(CurriculumTask.count).to eq 0
    expect(page).to have_content 'Falha ao adicionar tarefa.'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'and must be curriculum owner' do
    first_user = create(:user)
    first_user_curriculum = create(:curriculum, id: 1, user: first_user, schedule_item_code: 99)
    second_user = create(:user)
    create(:profile, user: second_user)

    login_as second_user, scope: :user
    visit new_curriculum_curriculum_task_path(first_user_curriculum)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Conteúdo indisponível'
  end
end
