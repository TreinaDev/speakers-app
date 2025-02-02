require 'rails_helper'

describe 'user view task list', type: :system do
  it 'and must be authenticated' do
    user = create(:user, first_name: 'João')
    create(:event_task, name: 'Tarefas iniciais básicas rails', user: user)
    create(:event_task, name: 'Revisão rails 8.0', user: user)

    visit event_tasks_path

    expect(current_path).to eq new_user_session_path
  end

  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    create(:event_task, name: 'Tarefas iniciais básicas rails', user: user)
    create(:event_task, name: 'Revisão rails 8.0', user: user)

    login_as user
    visit root_path
    click_on 'Tarefas'

    expect(page).to have_link 'Tarefas iniciais básicas rails'
    expect(page).to have_link 'Revisão rails 8.0'
    expect(current_path).to eq event_tasks_path
  end

  it 'and view only their tasks' do
    first_user = create(:user, first_name: 'João')
    create(:event_task, name: 'Revisão rails 8.0', user: first_user)
    second_user = create(:user, first_name: 'Roberto')
    create(:profile, user: second_user)
    create(:event_task, name: 'Tarefas iniciais básicas rails', user: second_user)

    login_as second_user
    visit event_tasks_path

    expect(page).not_to have_link 'Revisão rails 8.0'
    expect(page).to have_link 'Tarefas iniciais básicas rails'
  end

  it 'and dont have task previusly registered' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)

    login_as user
    visit root_path
    click_on 'Tarefas'

    expect(page).to have_content 'Não há tarefas cadastradas!'
    expect(current_path).to eq event_tasks_path
  end
end
