require 'rails_helper'

describe 'User register a new task to a curriculum', type: :request do
  it 'with success' do
    user = create(:user)
    create(:profile, user: user)
    curriculum = create(:curriculum, user: user)

    login_as user
    post curriculum_curriculum_tasks_path(curriculum), params: { curriculum_task: { title: 'Tarefa 01', description: 'Descrição', certificate_requirement: :optional } }

    task = CurriculumTask.last
    expect(CurriculumTask.count).to eq 1
    expect(task.title).to eq 'Tarefa 01'
    expect(task.description).to eq 'Descrição'
    expect(task.certificate_requirement).to eq 'optional'
  end

  it 'and must be authenticated' do
    user = create(:user)
    curriculum = create(:curriculum, user: user)

    post curriculum_curriculum_tasks_path(curriculum), params: { curriculum_task: { title: 'Tarefa 01', description: 'Descrição', certificate_requirement: :optional } }

    expect(CurriculumTask.count).to eq 0
    expect(response).to redirect_to new_user_session_path
  end

  it 'and must be the curriculum owner' do
    first_user = create(:user)
    curriculum = create(:curriculum, user: first_user)
    second_user = create(:user)
    create(:profile, user: second_user)

    login_as second_user
    post curriculum_curriculum_tasks_path(curriculum), params: { curriculum_task: { title: 'Tarefa 01', description: 'Descrição', certificate_requirement: :optional } }

    expect(CurriculumTask.count).to eq 0
    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq('Conteúdo indisponível!')
  end
end
