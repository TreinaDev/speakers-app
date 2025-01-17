require 'rails_helper'

describe 'User register tasks' do
  it 'must be authenticated' do
    visit new_event_task_path

    expect(page).not_to have_link 'Cadastrar Tarefa'
    expect(current_path).to eq new_user_session_path
  end

  it 'and see all the fields' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Tarefas'
    click_on 'Cadastrar Tarefa'

    expect(current_path).to eq new_event_task_path
    expect(page).to have_field 'Título'
    expect(page).to have_field 'Descrição'
    expect(page).to have_content 'Obrigatória para emissão de certificado'
    expect(page).to have_content 'Conteúdos'
  end
end
