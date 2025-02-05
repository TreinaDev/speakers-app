require 'rails_helper'

describe 'User mark content change as an update', type: :system, js: true do
  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Dev week'
    find("#pencil_edit").click
    fill_in 'Título', with: 'Workshop POO'
    fill_in_rich_text_area 'Descrição', with: 'Conteúdo do workshop de 09/04'
    check 'Marcar como atualização'
    fill_in 'event_content_update_description', with: 'Atualizando data na descrição do conteúdo'
    click_on 'Atualizar Conteúdo'

    expect(current_path).to eq event_content_path(content)
    expect(UpdateHistory.count).to eq 1
    expect(content.update_histories.count).to eq 1
    expect(page).to have_link 'Histórico de atualizações'
  end
end
