require 'rails_helper'

describe 'User view a curriculum task', type: :request do
  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    curriculum_task = create(:curriculum_task, curriculum: curriculum, title: 'Tarefa Teste', description: 'Descrição teste')

    get curriculum_curriculum_task_path(curriculum, curriculum_task)

    expect(response).to redirect_to new_user_session_path
  end

  it 'and must be the owner' do
    first_user = create(:user)
    second_user = create(:user)
    schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: first_user, schedule_item_code: schedule_item.code)
    curriculum_task = create(:curriculum_task, curriculum: curriculum, title: 'Tarefa Teste', description: 'Descrição teste')

    login_as second_user
    get curriculum_curriculum_task_path(curriculum, curriculum_task)

    expect(response).to redirect_to events_path
  end
end
