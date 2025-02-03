require 'rails_helper'

describe 'User add a new task', type: :request do
  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    first_event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    user.event_contents.create!(title: 'Ruby Introduction', description: 'Resumo do livro "Ruby: Aprenda a programar')

    login_as user, scope: :user
    post event_tasks_path, params: { event_task: {
                            name: 'Lição 01', description: 'Seção 01 de aprendizado',
                            certificate_requirement: :mandatory, event_content_ids: [ first_event_content.id ]
      } }

    expect(EventTask.count).to eq 1
    task = EventTask.last
    expect(task.name).to eq 'Lição 01'
    expect(task.description).to eq 'Seção 01 de aprendizado'
    expect(task.mandatory?).to eq true
    expect(task.event_contents.inspect).to include 'Dev week'
    expect(task.event_contents.inspect).not_to include 'Ruby Introduction'
  end

  it 'must be authenticated' do
    user = create(:user, first_name: 'João')
    first_event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    post event_tasks_path, params: { event_task: {
                            name: 'Lição 01', description: 'Seção 01 de aprendizado',
                            certificate_requirement: :mandatory, event_content_ids: [ first_event_content.id ]
      } }

    expect(EventTask.count).to eq 0
    expect(response).to redirect_to new_user_session_path
  end


  it 'and shouldnt save if use other user content' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    other_user = create(:user, first_name: 'Other')
    other_user_content = other_user.event_contents.create!(title: 'Ruby Introduction', description: 'Resumo do livro "Ruby: Aprenda a programar')

    login_as user, scope: :user
    post event_tasks_path, params: { event_task: {
                                    name: 'Lição 01', description: 'Seção 01 de aprendizado',
                                    certificate_requirement: :mandatory, event_content_ids: [ other_user_content.id ] } }

    expect(EventTask.count).to eq 0
    expect(response).to redirect_to event_tasks_path
  end
end
