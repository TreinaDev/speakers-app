require 'rails_helper'

describe 'User register a profile' do
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
    click_on 'Criar perfil'

    profile_test = Profile.first
    expect(current_path).to eq(events_path)
    expect(page).to have_content('Perfil cadastrado com sucesso.')
    expect(profile_test.title).to eq('Instrutor / Desenvolvedor')
    expect(profile_test.about_me).to eq('Sou João, desenvolvedor Ruby com foco em Ruby on Rails.')
    expect(profile_test.profile_picture.attached?).to eq(true)
  end
end
