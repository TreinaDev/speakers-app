require 'rails_helper'


describe 'User view update history' do
  it 'and must be content owner' do
    first_user = create(:user, first_name: 'João')
    event_content = first_user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    create(:update_history, user: first_user, event_content: event_content)
    second_user = create(:user, first_name: 'Luiz')
    create(:profile, user: second_user)

    login_as second_user
    get event_content_update_histories_path(event_content)

    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq('Conteúdo indisponível.')
  end
end
