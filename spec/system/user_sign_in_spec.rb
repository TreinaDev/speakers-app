require 'rails_helper'

describe 'Usuário acessa sua conta', type: :system do
  it 'com sucesso' do
    create(:user, first_name: 'João', last_name: 'Almeida', email: 'joao@campuscode.com', password: 'password')

    visit root_path
    click_on 'Acesse sua conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    expect(current_path).to eq events_path
    expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'e realiza seu logout em seguida' do
    create(:user, first_name: 'João', last_name: 'Almeida', email: 'joao@campuscode.com', password: 'password')

    visit root_path
    click_on 'Acesse sua conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
  end

  it 'e não preenche o formulário corretamente' do
    create(:user, password: '123456')

    visit root_path
    click_on 'Acesse sua conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'senhaIncorreta'
    click_on 'Entrar'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'E-mail ou senha inválidos.'
  end
end
