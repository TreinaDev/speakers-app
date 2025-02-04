require 'rails_helper'

describe 'User register a profile', type: :system do
  it 'must be authenticated' do
    visit new_profile_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'with success' do
    service = ExternalEventApi::UserFindEmailService
    code = { "code" => "ABCD1234" }
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return(code)

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
    select('Ele/Dele', from: 'Pronome')
    fill_in 'Cidade', with: 'Florianópolis'
    fill_in 'Data de Nascimento', with: '1999-01-25'
    select('Masculino', from: 'Gênero')
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
    expect(profile_test.pronoun).to eq('Ele/Dele')
    expect(profile_test.city).to eq('Florianópolis')
    expect(profile_test.birth.strftime('%d/%m/%Y')).to eq('25/01/1999')
    expect(profile_test.gender).to eq('Masculino')
    expect(profile_test.profile_picture.attached?).to eq(true)
    expect(networks.length).to eq(5)
    expect(networks.find_by(url: 'https://www.youtube.com/@JoãoTutoriais').present?).to eq(true)
    expect(networks.find_by(url: 'https://www.joaotutoriais.com/').present?).to eq(true)
    expect(networks.find_by(url: 'https://x.com/joao').present?).to eq(true)
    expect(networks.find_by(url: 'https://github.com/joaorsalmeida').present?).to eq(true)
    expect(networks.find_by(url: 'https://www.facebook.com/joaoalmeida').present?).to eq(true)
  end

  it 'with other gender and pronoun' do
    user = create(:user, first_name: 'João')
    service = ExternalEventApi::UserFindEmailService
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return("ABCD1234")

    login_as user
    visit new_profile_path
    fill_in 'Título', with: 'Instrutor / Desenvolvedor'
    fill_in 'Sobre mim', with: 'Sou João, desenvolvedor Ruby com foco em Ruby on Rails.'
    select('Outro', from: 'Pronome')
    fill_in 'Outro Pronome', with: 'Ellu / Dellu'
    fill_in 'Cidade', with: 'Florianópolis'
    fill_in 'Data de Nascimento', with: '1999-01-25'
    select('Outro', from: 'Gênero')
    fill_in 'Outro Gênero', with: 'Transgênero'
    attach_file('Foto de Perfil',  Rails.root.join('spec/fixtures/puts.png'))
    click_on 'Criar perfil'

    profile_test = Profile.first
    expect(current_path).to eq(events_path)
    expect(page).to have_content('Perfil cadastrado com sucesso.')
    expect(profile_test.title).to eq('Instrutor / Desenvolvedor')
    expect(profile_test.about_me).to eq('Sou João, desenvolvedor Ruby com foco em Ruby on Rails.')
    expect(profile_test.pronoun).to eq('Ellu / Dellu')
    expect(profile_test.city).to eq('Florianópolis')
    expect(profile_test.birth.strftime('%d/%m/%Y')).to eq('25/01/1999')
    expect(profile_test.gender).to eq('Transgênero')
    expect(profile_test.profile_picture.attached?).to eq(true)
  end

  it 'with blank fields' do
    user = create(:user, first_name: 'João')

    login_as user
    visit new_profile_path
    fill_in 'Título', with: ''
    fill_in 'Sobre mim', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Data de Nascimento', with: ''
    click_on 'Criar perfil'

    expect(page).to have_content('Falha ao registrar o perfil.')
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Sobre mim não pode ficar em branco')
    expect(page).to have_content('Foto de Perfil não pode ficar em branco')
    expect(page).to have_content('Data de Nascimento não pode ficar em branco')
    expect(page).to have_content('Gênero não pode ficar em branco')
    expect(page).to have_content('Pronome não pode ficar em branco')
    expect(page).to have_content('Cidade não pode ficar em branco')
  end

  it 'with blank fields for gender and pronoun' do
    user = create(:user, first_name: 'João')

    login_as user
    visit new_profile_path
    select('Outro', from: 'Pronome')
    fill_in 'Outro Pronome', with: ''
    select('Outro', from: 'Gênero')
    fill_in 'Outro Gênero', with: ''
    click_on 'Criar perfil'

    expect(page).to have_content('Falha ao registrar o perfil.')
    expect(page).to have_content('Gênero não pode ficar em branco')
    expect(page).to have_content('Pronome não pode ficar em branco')
  end

  it 'with invalid network' do
    user = create(:user, first_name: 'João')
    service = ExternalEventApi::UserFindEmailService
    allow_any_instance_of(service).to receive(:presence_fetch_api_email?).and_return("ABCD1234")

    login_as user
    visit new_profile_path
    fill_in 'Título', with: 'Instrutor / Desenvolvedor'
    fill_in 'Sobre mim', with: 'Sou João, desenvolvedor Ruby com foco em Ruby on Rails.'
    attach_file('Foto de Perfil',  Rails.root.join('spec/fixtures/puts.png'))
    fill_in 'Meu site', with: 'joaotutoriais'
    fill_in 'Youtube', with: 'https://www.you.com/@JoãoTutoriais'
    fill_in 'Twitter', with: 'https://twitter12547.com/joao'
    fill_in 'GitHub', with: 'https://githubpirata.com/joaorsalmeida'
    fill_in 'Facebook', with: 'https://www.booktable.com/joaoalmeida'
    click_on 'Criar perfil'

    expect(page).to have_content('Falha ao registrar o perfil.')
    expect(page).to have_content('Url inválida para Youtube')
    expect(page).to have_content('Url inválida para X')
    expect(page).to have_content('Url inválida para GitHub')
    expect(page).to have_content('Url inválida para Facebook')
    expect(page).to have_content('Url inválida para Meu Site')
  end

  it 'for the second time' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)

    login_as user
    visit new_profile_path

    expect(current_path).to eq(events_path)
    expect(page).not_to have_content('Cadastrar Perfil')
    expect(page).to have_content('Só é possível cadastrar um perfil.')
  end

  it 'through the register button' do
    user = create(:user, first_name: 'João')

    login_as user
    visit new_profile_path

    expect(current_path).to eq(new_profile_path)
    expect(page).not_to have_content('Meu Perfil')
    expect(page).to have_content('Cadastre seu perfil')
  end

  it 'and select private fields' do
    user = create(:user, first_name: 'João')

    login_as user
    visit new_profile_path
    fill_in 'Título', with: 'Instrutor / Desenvolvedor'
    fill_in 'Sobre mim', with: 'Sou João, desenvolvedor Ruby com foco em Ruby on Rails.'
    select('Ele/Dele', from: 'Pronome')
    uncheck 'Exibir Pronome'
    fill_in 'Cidade', with: 'Florianópolis'
    uncheck 'Exibir Cidade'
    fill_in 'Data de Nascimento', with: '1999-01-25'
    uncheck 'Exibir Data de Nascimento'
    select('Masculino', from: 'Gênero')
    check 'Exibir Gênero'
    attach_file('Foto de Perfil',  Rails.root.join('spec/fixtures/puts.png'))
    click_on 'Criar perfil'

    profile = Profile.first
    expect(current_path).to eq(events_path)
    expect(page).to have_content('Perfil cadastrado com sucesso.')
    expect(profile.display_pronoun).to eq(false)
    expect(profile.display_gender).to eq(true)
    expect(profile.display_city).to eq(false)
    expect(profile.display_birth).to eq(false)
  end
end
