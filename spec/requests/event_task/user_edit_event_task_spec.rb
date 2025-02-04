require 'rails_helper'

describe 'User edit content' do
  it 'and try to edit another user task' do
    first_user = create(:user, first_name: 'Erika')
    task = first_user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')
    second_user = create(:user, first_name: 'Otávio')
    create(:profile, user: second_user)

    login_as second_user
    patch(event_task_path(task.id), params: { event_task: { name: 'Atividades avançadas', description: 'Descrição falsa' } })

    expect(response).to redirect_to events_path
    expect(task.name).to eq 'Tarefa inicial'
  end
end
