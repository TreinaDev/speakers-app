require 'rails_helper'

describe 'User register tasks' do
  it 'must be authenticated' do
    visit new_event_task_path

    expect(page).not_to have_link 'Cadastrar Tarefa'
    expect(current_path).to eq new_user_session_path
  end


  it 'with success' do
    user = create(:user)
    create(:event_content, title: 'My content', description: 'My own content', user: user)

    login_as user
    visit new_event_task_path

    fill_in 'Título', with: 'Tarefa 01'
    fill_in 'Descrição', with: 'Lorem ipsum'
    choose 'Obrigatória'
    check 'My content'
    click_on 'Salvar'

    expect(page).to have_content('Tarefa cadastrada com sucesso!')
    expect(EventTask.count).to eq 1
    expect(current_path).to eq event_tasks_path
  end

  it 'with success without content' do
    user = create(:user)

    login_as user
    visit new_event_task_path

    fill_in 'Título', with: 'Tarefa 01'
    fill_in 'Descrição', with: 'Lorem ipsum'
    choose 'Obrigatória'
    click_on 'Salvar'

    expect(EventTask.count).to eq 1
    expect(page).to have_content('Tarefa cadastrada com sucesso!')
    expect(current_path).to eq event_tasks_path
  end

  it 'and shouldnt see other users content' do
    user = create(:user)
    create(:event_content, title: 'My content', description: 'My own content', user: user)
    other_user = create(:user, first_name: 'other', email: 'other_user@email.com')
    create(:event_content, title: 'Other user content', description: 'The other user content', user: other_user)

    login_as user
    visit root_path
    click_on 'Tarefas'
    click_on 'Cadastrar Tarefa'

    expect(page).to have_field('My content', type: 'checkbox')
    expect(page).not_to have_field('Other user content', type: 'checkbox')
  end

  it 'and not fill mandatory fields ' do
    user = create(:user)
    create(:event_content, title: 'My content', description: 'My own content', user: user)

    login_as user
    visit new_event_task_path
    click_on 'Salvar'

    expect(EventTask.count).to eq 0
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end

  it 'and optional should be checked by default' do
    user = create(:user)
    create(:event_content, title: 'My content', description: 'My own content', user: user)

    login_as user
    visit new_event_task_path

    expect(page).to have_checked_field('Opcional')
  end
end
