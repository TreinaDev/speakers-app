require 'rails_helper'

describe 'User view a curriculum content', type: :request do
  it 'and must be authenticated' do
    user = create(:user)
    schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')
    content = user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.id)
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)

    get curriculum_curriculum_content_path(curriculum, curriculum_content)

    expect(response).to redirect_to new_user_session_path
  end

  it 'and must be the owner' do
    first_user = create(:user)
    second_user = create(:user)
    schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')
    content = first_user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD')
    curriculum = create(:curriculum, user: first_user, schedule_item_code: schedule_item.id)
    curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: content)

    login_as second_user
    get curriculum_curriculum_content_path(curriculum, curriculum_content)

    expect(response).to redirect_to events_path
  end
end
