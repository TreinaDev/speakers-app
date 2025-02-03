require 'rails_helper'

describe 'User register a content', type: :system, js: true do
  it 'must be authenticated' do
    visit new_event_content_path

    expect(page).not_to have_link 'Cadastrar Conteúdo'
    expect(current_path).to eq new_user_session_path
  end

  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)

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
    expect(current_path).to eq event_content_path(EventContent.last)
  end

  it 'and adds an external video from youtube' do
    user = create(:user)

    login_as user
    visit new_event_content_path
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Seu primeiro contato com o melhor amigo dos programadores.'
    fill_in 'URL do seu vídeo', with: 'https://www.youtube.com/watch?v=PbxBtQH5R_o'
    click_on 'Criar Conteúdo'

    expect(current_path).to eq event_content_path(EventContent.last)
    expect(EventContent.count).to eq 1
    expect(EventContent.last.external_video_url.present?).to eq true
    expect(page).to have_content 'Conteúdo registrado com sucesso.'
    expect(page).to have_css "iframe#external-video"
    expect(page).to have_css "iframe[src='https://www.youtube.com/embed/PbxBtQH5R_o']"
  end

  it 'and adds an external video from vimeo' do
    user = create(:user)

    login_as user
    visit new_event_content_path
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Seu primeiro contato com o melhor amigo dos programadores.'
    fill_in 'URL do seu vídeo', with: 'https://vimeo.com/1047790821'
    click_on 'Criar Conteúdo'

    expect(current_path).to eq event_content_path(EventContent.last)
    expect(EventContent.count).to eq 1
    expect(EventContent.last.external_video_url.present?).to eq true
    expect(page).to have_content 'Conteúdo registrado com sucesso.'
    expect(page).to have_css "iframe#external-video"
    expect(page).to have_css "iframe[src='https://player.vimeo.com/video/1047790821']"
  end

  it 'and external video url must be valid' do
    user = create(:user)

    login_as user
    visit events_path
    click_on 'Meus Conteúdos'
    click_on 'Cadastrar Conteúdo'
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Seu primeiro contato com o melhor amigo dos programadores.'
    fill_in 'URL do seu vídeo', with: 'google.com'
    click_on 'Criar Conteúdo'

    expect(EventContent.count).to eq 0
    expect(page).to have_content 'Falha ao registrar o conteúdo.'
    expect(page).to have_field 'URL do seu vídeo'
      expect(page).to have_content 'URL do seu vídeo é inválida.'
  end

  it 'failure with more than 5 files' do
    user = create(:user)
    create(:profile, user: user)

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
    expect(page).not_to have_content 'mark_zuckerberg.jpeg'
    expect(page).not_to have_content 'capi.png'
    expect(page).not_to have_content 'puts.png'
    expect(page).not_to have_content 'joker.mp4'
    expect(page).not_to have_content 'nota-ufjf.pdf'
    expect(page).not_to have_content 'Reunião.pdf'
  end

  it 'failure with file larger than 50mb' do
    user = create(:user)
    create(:profile, user: user)

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
    expect(page).not_to have_content 'Arquivos já anexados:'
    expect(page).not_to have_content 'Topicos de Fisica.pdf'
  end

  it 'failure if title is empty' do
    user = create(:user)
    create(:profile, user: user)

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

  it 'and cancels' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Cadastrar Conteúdo'
    fill_in 'Título', with: 'Ruby para iniciantes'
    fill_in_rich_text_area 'Descrição', with: 'Um guia sobre o mundo dos desenvolvedores felizes.'
    click_on 'Cancelar'

    expect(EventContent.count).to eq 0
    expect(current_path).to eq event_contents_path
  end
end
