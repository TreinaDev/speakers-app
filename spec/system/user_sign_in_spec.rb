require 'rails_helper'

describe 'Usuário acessa sua conta', type: :system do
  it 'com sucesso' do
    user = create(:user, first_name: 'João', last_name: 'Almeida', email: 'joao@campuscode.com', password: 'password')

    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso.'
  end
end