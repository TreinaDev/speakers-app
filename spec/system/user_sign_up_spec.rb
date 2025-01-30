require 'rails_helper'

describe 'Speacker create account', type: :system do
  it 'and must be previusly registred' do
    error = { "error"=> "Palestrante não encontrado." }
    response = double('response', status: 404, success?: false, body: error.to_json)
    connection = instance_double(Faraday::Connection)
    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:post).and_return(response)

    visit root_path
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@campuscode.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    click_on 'Cadastrar'

    expect(User.count).to eq 0
    expect(page).to have_content 'Palestrante não encontrado.'
    expect(page).to have_content 'Token não pode ficar em branco'
  end

  it 'with success' do
    service = ExternalEventApi::UserFindEmailService
    token = { "token"=> "ABCD1234" }
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return(token)

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

  it 'and fail with empty fields' do
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

  it 'and fails when API do not work' do
    connection = instance_double(Faraday::Connection)
    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:post).and_return(Faraday::ConnectionFailed)

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
