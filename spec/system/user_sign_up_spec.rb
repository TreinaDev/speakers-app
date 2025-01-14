require 'rails_helper'

describe 'Palestrante cria a sua conta', type: :system, js: true do
  it 'e deve estar previamente cadastrado' do
    visit root_path
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    click_on 'Cadastrar'

    expect(User.count).to eq 0
    expect(page).not_to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
  end

  it 'com sucesso' do
    
  end
end

# thiagogoes1011@gmail.com
# pedroddias98@gmail.com