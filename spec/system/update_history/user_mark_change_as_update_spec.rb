require 'rails_helper'

describe 'User mark content change as an update', type: :system, js: true do
  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    within("#event_content_1") do
      click_on 'Visualizar conteúdo'
    end
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

  it 'and must inform update description' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    login_as user
    visit edit_event_content_path(content)
    check 'Marcar como atualização'
    fill_in 'event_content_update_description', with: ''
    click_on 'Atualizar Conteúdo'

    expect(UpdateHistory.count).to eq 0
    expect(page).to have_content 'Não foi possível atualizar seu Conteúdo.'
    expect(page).to have_content 'Comentário da atualização não pode ficar em branco'
  end

  it 'and update history is not created if event content is invalid' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    login_as user
    visit edit_event_content_path(content)
    fill_in 'Título', with: ''
    check 'Marcar como atualização'
    fill_in 'event_content_update_description', with: 'Esse conteúdo deve ser inválido'
    click_on 'Atualizar Conteúdo'

    expect(UpdateHistory.count).to eq 0
    expect(page).to have_content 'Não foi possível atualizar seu Conteúdo.'
  end
end
