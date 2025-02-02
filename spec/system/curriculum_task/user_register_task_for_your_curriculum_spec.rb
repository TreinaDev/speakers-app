require 'rails_helper'

describe 'User register task for your schedule item curriculum', type: :system, js: true do
  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.id)

    visit new_curriculum_curriculum_task_path(curriculum)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'with success' do
    user = create(:user)
    create(:profile, user: user)
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
    click_on 'Adicionar tarefa'
    fill_in 'Título', with: 'Tarefa 01'
    fill_in 'Descrição', with: 'Lorem ipsum'
    choose 'Obrigatória'
    click_on 'Adicionar'

    expect(CurriculumTask.count).to eq 1
    expect(current_path).to eq schedule_item_path(schedule_items.first.id)
    expect(page).to have_content 'Tarefa adicionada com sucesso!'
    expect(page).to have_content 'Tarefa 01'
  end

  it 'and must fill all required fields' do
    user = create(:user)
    create(:profile, user: user)
    schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)

    login_as user, scope: :user
    visit schedule_item_path(schedule_item.id)
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
