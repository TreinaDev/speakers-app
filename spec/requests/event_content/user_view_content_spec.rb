require 'rails_helper'

describe 'User view a content', type: :request do
  it 'must be authenticated' do
    user = create(:user, first_name: 'João')
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    get event_content_path(event_content)

    expect(response).to redirect_to new_user_session_path
  end

  it 'but is not authorized to view it for other users' do
    first_user = create(:user, first_name: 'João')
    event_content = first_user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    second_user = create(:user, first_name: 'Luiz')

    login_as second_user
    get event_content_path(event_content)

    expect(response).to redirect_to events_path
  end
end
