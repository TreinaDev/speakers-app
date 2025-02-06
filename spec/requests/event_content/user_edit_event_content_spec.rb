require 'rails_helper'

describe 'User edit an event content', type: :request do
  it 'and must be the content owner' do
    first_user = create(:user)
    event_content = create(:event_content, user: first_user, title: 'Stimulus para iniciantes')
    second_user = create(:user)
    create(:profile, user: second_user)

    login_as second_user
    put event_content_path(event_content), params: { event_content: { title: 'Ruby para Iniciantes',
                                                     is_update: 1, update_description: 'Descrição maliciosa' } }

    expect(EventContent.last.title).to eq 'Stimulus para iniciantes'
    expect(UpdateHistory.count).to eq 0
    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq('Conteúdo Indisponível!')
  end
end
