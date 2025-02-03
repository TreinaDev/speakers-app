require 'rails_helper'

describe 'User access contents list', type: :system do
  it 'and view registered contents' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
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

  it 'and view your own registered contents' do
    firt_user = create(:user, first_name: 'João')
    second_user = create(:user, first_name: 'Matheus')
    create(:profile, user: second_user)
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

  it 'and dont have content previusly registered' do
    user = create(:user, first_name: 'João')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'

    expect(page).to have_content 'Não há conteúdos cadastrados!'
    expect(current_path).to eq event_contents_path
  end
end
