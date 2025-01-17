require 'rails_helper'

describe 'User access contents list', type: :system do
  it 'and view registered contents' do
    user = create(:user, first_name: 'João')
    user.event_contents.create(title: 'Introdução', description: 'Apresentação')
    user.event_contents.create(title: 'Desenvolvimento', description: 'Lógica de Programação')
    user.event_contents.create(title: 'Avançado', description: 'POO')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'

    expect(page).to have_content 'Introdução'
    expect(page).to have_content 'Desenvolvimento'
    expect(page).to have_content 'Avançado'
  end

  it 'and view registered contents' do
    firt_user = create(:user, first_name: 'João')
    second_user = create(:user, first_name: 'Matheus')
    firt_user.event_contents.create(title: 'Introdução', description: 'Apresentação')
    firt_user.event_contents.create(title: 'Desenvolvimento', description: 'Lógica de Programação')
    second_user.event_contents.create(title: 'Avançado', description: 'POO')

    login_as second_user
    visit root_path
    click_on 'Meus Conteúdos'

    expect(page).not_to have_content 'Introdução'
    expect(page).not_to have_content 'Desenvolvimento'
    expect(page).to have_content 'Avançado'
  end

  it 'must be authenticated' do
    visit root_path

    expect(page).not_to have_link 'Meus Conteúdos'
  end
end
