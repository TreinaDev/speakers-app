require 'rails_helper'

describe 'User register a content', type: :system, js: true do
  it 'must be authenticated' do
    visit new_event_content_path

    expect(page).not_to have_link 'Cadastrar Conteúdo'
    expect(current_path).to eq new_user_session_path
  end

  it 'with success' do
    user = create(:user, first_name: 'João')

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Cadastrar Conteúdo'
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Um guia sobre o mundo dos desenvolvedores felizes.'
    attach_file('Arquivos', [ Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'),
                              Rails.root.join('spec/fixtures/capi.png'),
                              Rails.root.join('spec/fixtures/puts.png'),
                              Rails.root.join('spec/fixtures/joker.mp4'),
                              Rails.root.join('spec/fixtures/nota-ufjf.pdf')
                            ])
    click_on 'Criar Conteúdo'

    files = EventContent.last.files
    expect(EventContent.count).to eq 1
    expect(files.attached?).to eq true
    expect(files.count).to eq 5
    expect(page).to have_content 'Conteúdo registrado com sucesso.'
  end

  it 'failure with more than 5 files' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Cadastrar Conteúdo'
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Um guia sobre o mundo dos desenvolvedores felizes.'
    attach_file('Arquivos', [ Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'),
                              Rails.root.join('spec/fixtures/capi.png'),
                              Rails.root.join('spec/fixtures/puts.png'),
                              Rails.root.join('spec/fixtures/joker.mp4'),
                              Rails.root.join('spec/fixtures/nota-ufjf.pdf'),
                              Rails.root.join('spec/fixtures/Reunião.pdf')
                            ])
    click_on 'Criar Conteúdo'

    expect(EventContent.count).to eq 0
    expect(page).to have_content 'Falha ao registrar o conteúdo.'
    expect(page).to have_content 'Não é possível enviar mais que 5 arquivos.'
  end

  it 'failure with file larger than 50mb' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Cadastrar Conteúdo'
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Um guia sobre o mundo dos desenvolvedores felizes.'
    attach_file('Arquivos', [ Rails.root.join('spec/fixtures/Topicos de Fisica.pdf') ])
    click_on 'Criar Conteúdo'

    expect(EventContent.count).to eq 0
    expect(page).to have_content 'Falha ao registrar o conteúdo.'
    expect(page).to have_content 'Não é possível enviar arquivos com mais de 50mb.'
  end

  it 'failure if title is empty' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Cadastrar Conteúdo'
    fill_in 'Título', with: ''
    fill_in_rich_text_area 'Descrição', with: 'Um guia sobre o mundo dos desenvolvedores felizes.'
    click_on 'Criar Conteúdo'

    expect(EventContent.count).to eq 0
    expect(page).to have_content 'Falha ao registrar o conteúdo.'
    expect(page).to have_content 'Título não pode ficar em branco'
  end
end
