require 'rails_helper'

describe 'user edit task', type: :system, js: true do
  it 'and must be authenticated' do
    user = create(:user, first_name: 'João')
    task = user.event_tasks.create!(name: 'Tarefa Ruby', description: 'Tarefa para iniciantes')

    visit edit_event_task_path(task)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'with success' do
    user = create(:user)
    content = create(:event_content, title: 'My content', description: 'My own content', user: user)
    task = user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')
    EventTaskContent.create!(event_content: content, event_task: task)
    create(:event_content, title: 'Second Content', description: 'My second content', user: user)

    login_as user
    visit event_tasks_path
    click_on 'Tarefa inicial'
    find("#pencil_edit").click
    check 'My content'
    check 'Second Content'
    fill_in 'Título', with: 'Conteúdo editado'
    fill_in 'Descrição', with: 'Descrição editada'
    choose 'Obrigatória'
    click_on 'Salvar'

    expect(current_path).to eq event_task_path(task)
    expect(page).to have_content 'Tarefa atualizada com sucesso!'
    expect(page).to have_content 'Conteúdo editado'
    expect(page).to have_content 'Descrição editada'
    expect(page).to have_content 'Obrigatória'
    expect(page).to have_link 'Second Content'
    expect(page).not_to have_link 'My Content'
  end

  it 'failure if title or description are empty' do
    user = create(:user)
    task = user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')

    login_as user
    visit event_task_path(task)
    find("#pencil_edit").click
    fill_in 'Título', with: ''
    fill_in 'Descrição', with: ''
    choose 'Obrigatória'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar sua tarefa.'
    expect(task.optional?).to be true
  end

  it 'and must be the owner' do
    user = create(:user)
    user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')
    user2 = create(:user)
    task2 = user2.event_tasks.create!(name: 'Tarefa Ruby Básica', description: 'Principios TDD')

    login_as user
    visit edit_event_task_path(task2)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Acesso não autorizado.'
  end
end
