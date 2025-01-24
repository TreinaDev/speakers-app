require 'rails_helper'

describe 'User edit event content', type: :system, js: true do
  it 'and must be authenticated' do
    user = create(:user, first_name: 'João')
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    visit edit_event_content_path(content)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and must be the owner' do
    first_user = create(:user)
    second_user = create(:user, first_name: 'Pedro')
    content = first_user.event_contents.create!(title: 'Workshop Rails', description: 'Boas-vindas ao melhor workshop do Brasil!')

    login_as second_user
    visit edit_event_content_path(content)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Conteúdo Indisponível!'
  end

  it 'with sucess' do
    user = create(:user, first_name: 'João')
    image_1 = fixture_file_upload(Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'))
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01', files: [ image_1 ])

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Dev week'
    find("#pencil_edit").click
    fill_in 'Título', with: 'Workshop POO'
    fill_in_rich_text_area 'Descrição', with: 'Conetúdo para auxiliar o workshop POO'
    attach_file('Arquivos', [ Rails.root.join('spec/fixtures/puts.png') ])
    click_on 'Atualizar Conteúdo'

    expect(current_path).to eq event_content_path(content)
    expect(page).not_to have_content 'Dev week'
    expect(page).to have_content 'Conteúdo atualizado com sucesso!'
    expect(page).to have_content 'Workshop POO'
    expect(page).to have_content 'Conetúdo para auxiliar o workshop POO'
    expect(page).to have_css("img[src*='puts.png']")
    expect(page).to have_css("img[src*='mark_zuckerberg.jpeg']")
  end

  it 'failure if title is empty' do
    user = create(:user, first_name: 'João')
    user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Dev week'
    find("#pencil_edit").click
    fill_in 'Título', with: ''
    fill_in_rich_text_area 'Descrição', with: 'Conetúdo para auxiliar o workshop POO'
    click_on 'Atualizar Conteúdo'

    expect(page).to have_content 'Não foi possível atualizar seu Conteúdo.'
    expect(page).to have_content 'Título não pode ficar em branco'
  end
end
