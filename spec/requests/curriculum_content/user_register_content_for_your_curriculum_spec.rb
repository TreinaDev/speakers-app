require 'rails_helper'

describe 'User register content for your curriculum', type: :request  do
  it 'with success' do
    user = create(:user)
    create(:event_content, id: 11, user: user)
    curriculum = create(:curriculum, id: 1, user: user, schedule_item_code: 99)

    login_as user
    post curriculum_curriculum_contents_path(curriculum), params: { curriculum_content: { event_content_id: 11 } }

    expect(CurriculumContent.count).to eq 1
    curriculum_content = CurriculumContent.last
    expect(curriculum_content.curriculum_id).to eq 1
    expect(curriculum_content.event_content_id).to eq 11
  end

  it 'and content is already attached' do
    user = create(:user)
    event_content = create(:event_content, id: 11, user: user)
    curriculum = create(:curriculum, id: 1, user: user, schedule_item_code: 99)
    create(:curriculum_content, curriculum: curriculum, event_content: event_content)

    login_as user
    post curriculum_curriculum_contents_path(curriculum), params: { curriculum_content: { event_content_id: 11 } }

    expect(CurriculumContent.count).to eq 1
    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq('Falha ao adicionar conteúdo.')
  end

  it 'and must be authenticated' do
    user = create(:user)
    create(:event_content, id: 11, user: user)
    curriculum = create(:curriculum, id: 1, user: user, schedule_item_code: 99)

    post curriculum_curriculum_contents_path(curriculum), params: { curriculum_content: { event_content_id: 11 } }

    expect(CurriculumContent.count).to eq 0
    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq('Para continuar, faça login ou registre-se.')
  end

  it 'and must be the curriculum owner' do
    first_user = create(:user)
    create(:event_content, id: 11, user: first_user)
    curriculum = create(:curriculum, id: 1, user: first_user, schedule_item_code: 99)
    second_user = create(:user)

    login_as second_user
    post curriculum_curriculum_contents_path(curriculum), params: { curriculum_content: { event_content_id: 11 } }

    expect(CurriculumContent.count).to eq 0
    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq('Conteúdo indisponível!')
  end
end
