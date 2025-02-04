require 'rails_helper'

describe 'User view task details', type: :system do
  it 'with sucess' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    content = user.event_contents.create!(title: 'Conteúdo de ruby')
    task = user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')
    EventTaskContent.create!(event_content: content, event_task: task)

    login_as user
    visit root_path
    click_on 'Tarefas'
    click_on 'Tarefa inicial'

    expect(current_path).to eq event_task_path(task)
    expect(page).to have_content 'Tarefa inicial'
    expect(page).to have_content 'Desafio para iniciantes'
    expect(page).to have_content 'Tarefa Opcional'
    expect(page).to have_content 'Conteúdos vinculados'
    expect(page).to have_link 'Conteúdo de ruby'
  end

  it 'and user is not authenticated' do
    user = create(:user, first_name: 'João')
    task = user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')

    visit event_task_path(task)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content('Tarefa inicial')
  end

  it 'not see task for other users' do
    first_user = create(:user, first_name: 'João')
    first_user_task = first_user.event_tasks.create!(name: 'Dev week', description: 'Tarefa inicial para estudo prévio da palestra')
    second_user = create(:user, first_name: 'Luiz')
    create(:profile, user: second_user)

    login_as second_user
    visit event_task_path(first_user_task)

    expect(current_path).to eq events_path
    expect(page).to have_content ('Acesso não autorizado.')
  end
end
