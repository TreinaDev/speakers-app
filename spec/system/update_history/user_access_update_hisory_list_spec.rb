require 'rails_helper'

describe 'User access update history list' do
  it 'and must be authenticated' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    create(:update_history, user: user, event_content: event_content)

    visit event_content_update_histories_path(event_content)

    expect(current_path).to eq new_user_session_path
  end

  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    other_event_content = user.event_contents.create!(title: 'Outro conteúdo')
    create(:update_history, user: user, event_content: event_content, creation_date: Date.today,
           description: 'Primeira alteração no conteúdo')
    create(:update_history, user: user, event_content: event_content,
           description: 'Segunda alteração no conteúdo')
    create(:update_history, user: user, event_content: other_event_content,
           description: 'Uma alteração no outro conteúdo')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    within("#event_content_1") do
      click_on 'Visualizar conteúdo'
    end
    click_on 'Histórico de atualizações'

    expect(page).to have_content Date.today.strftime('%d/%m/%Y')
    expect(page).to have_content 'Primeira alteração no conteúdo'
    expect(page).to have_content 'Segunda alteração no conteúdo'
    expect(page).not_to have_content 'Uma alteração no outro conteúdo'
  end

  it 'and must be the content owner' do
    first_user = create(:user, first_name: 'João')
    event_content = first_user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    create(:update_history, user: first_user, event_content: event_content)
    second_user = create(:user, first_name: 'Luiz')
    create(:profile, user: second_user)

    login_as second_user
    visit event_content_update_histories_path(event_content)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Conteúdo indisponível'
  end
end
