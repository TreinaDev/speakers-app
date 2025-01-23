require 'rails_helper'

describe 'User register a profile' do
  it 'must be authenticated' do
    visit new_profile_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'with success' do
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
    fill_in 'Título', with: 'Instrutor / Desenvolvedor'
    fill_in 'Sobre mim', with: 'Sou João, desenvolvedor Ruby com foco em Ruby on Rails.'
    attach_file('Foto de Perfil',  Rails.root.join('spec/fixtures/puts.png'))
    fill_in 'Meu site', with: 'https://www.joaotutoriais.com/'
    fill_in 'Youtube', with: 'https://www.youtube.com/@JoãoTutoriais'
    fill_in 'Twitter', with: 'https://x.com/joao'
    fill_in 'GitHub', with: 'https://github.com/joaorsalmeida'
    fill_in 'Facebook', with: 'https://www.facebook.com/joaoalmeida'
    click_on 'Criar perfil'

    profile_test = Profile.first
    networks = profile_test.social_networks
    expect(current_path).to eq(events_path)
    expect(page).to have_content('Perfil cadastrado com sucesso.')
    expect(profile_test.title).to eq('Instrutor / Desenvolvedor')
    expect(profile_test.about_me).to eq('Sou João, desenvolvedor Ruby com foco em Ruby on Rails.')
    expect(profile_test.profile_picture.attached?).to eq(true)
    expect(networks.length).to eq(5)
    expect(networks.find_by(url: 'https://www.youtube.com/@JoãoTutoriais').present?).to eq(true)
    expect(networks.find_by(url: 'https://www.joaotutoriais.com/').present?).to eq(true)
    expect(networks.find_by(url: 'https://x.com/joao').present?).to eq(true)
    expect(networks.find_by(url: 'https://github.com/joaorsalmeida').present?).to eq(true)
    expect(networks.find_by(url: 'https://www.facebook.com/joaoalmeida').present?).to eq(true)
  end

  it 'with blank fields' do
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
    fill_in 'Título', with: ''
    fill_in 'Sobre mim', with: ''
    click_on 'Criar perfil'

    expect(current_path).to eq(profiles_path)
    expect(page).to have_content('Falha ao registrar o perfil.')
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Sobre mim não pode ficar em branco')
    expect(page).to have_content('Foto de Perfil não pode ficar em branco')
  end

  it 'with invalid network' do
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
    fill_in 'Título', with: 'Instrutor / Desenvolvedor'
    fill_in 'Sobre mim', with: 'Sou João, desenvolvedor Ruby com foco em Ruby on Rails.'
    attach_file('Foto de Perfil',  Rails.root.join('spec/fixtures/puts.png'))
    fill_in 'Meu site', with: 'joaotutoriais'
    fill_in 'Youtube', with: 'https://www.you.com/@JoãoTutoriais'
    fill_in 'Twitter', with: 'https://twitter12547.com/joao'
    fill_in 'GitHub', with: 'https://githubpirata.com/joaorsalmeida'
    fill_in 'Facebook', with: 'https://www.booktable.com/joaoalmeida'
    click_on 'Criar perfil'

    expect(current_path).to eq(profiles_path)
    expect(page).to have_content('Falha ao registrar o perfil.')
    expect(page).to have_content('Rede Social não é válido')
    expect(page).to have_content('Url inválida para YouTube')
    expect(page).to have_content('Url inválida para Twitter')
    expect(page).to have_content('Url inválida para GitHub')
    expect(page).to have_content('Url inválida para Facebook')
    expect(page).to have_content('Url inválida para Meu Site')
  end

  it 'for the second time' do
    service = ExternalEventApi::UserFindEmailService
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return(true)
    user = create(:user, first_name: 'João')
    create(:profile, user: user)

    login_as user
    visit new_profile_path

    expect(current_path).to eq(events_path)
    expect(page).not_to have_content('Cadastrar Perfil')
    expect(page).to have_content('Só é possível cadastrar um perfil.')
  end
end
