require 'rails_helper'

describe 'Palestrante cria a sua conta', type: :system do
  it 'e deve estar previamente cadastrado' do
    response = double('response', status: 404, success?: false)
    allow(Faraday).to receive(:get).and_return(response)

    visit root_path
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    click_on 'Cadastrar'

    expect(User.count).to eq 0
    expect(page).to have_content 'Algo deu errado, contate o responsável.'
  end

  it 'com sucesso' do
    service = ExternalEventApi::UserFindEmailService
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return(true)

    visit root_path
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    click_on 'Cadastrar'

    expect(User.count).to eq 1
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
  end

  it 'e falha devido a campos vazios' do
    visit root_path
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    click_on 'Cadastrar'

    expect(User.count).to eq 0
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
  end

  it 'falha devido a indisponibilidade da Api' do
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

    visit root_path
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    click_on 'Cadastrar'

    expect(User.count).to eq 0
    expect(page).to have_content 'Algo deu errado, contate o responsável.'
  end
end
