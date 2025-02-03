require 'rails_helper'

describe 'User register a new task to a curriculum', type: :request do
  it 'with success' do
    user = create(:user)
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

    login_as second_user
    post curriculum_curriculum_tasks_path(curriculum), params: { curriculum_task: { title: 'Tarefa 01', description: 'Descrição', certificate_requirement: :optional } }

    expect(CurriculumTask.count).to eq 0
    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq('Conteúdo indisponível!')
  end

  it 'and must be the curriculum content owner' do
    first_user = create(:user)
    curriculum = create(:curriculum, user: first_user)
    event_content = create(:event_content, user: first_user, title: 'Ruby on Rails')
    first_user_curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: event_content)
    second_user = create(:user)
    second_user_curriculum = create(:curriculum, user: second_user)

    login_as second_user
    post curriculum_curriculum_tasks_path(second_user_curriculum), params: { curriculum_task: { title: 'Tarefa 01', description: 'Descrição', certificate_requirement: :optional, curriculum_content_ids: [ first_user_curriculum_content.id ] } }

    expect(CurriculumTask.count).to eq 0
    expect(response).to redirect_to schedule_item_path(second_user_curriculum.schedule_item_code)
  end
end
