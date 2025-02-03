require 'rails_helper'

describe 'User view a content', type: :system do
  it 'with success' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    pdf_1 = fixture_file_upload(Rails.root.join('spec/fixtures/nota-ufjf.pdf'))
    image_1 = fixture_file_upload(Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'))
    image_2 = fixture_file_upload(Rails.root.join('spec/fixtures/capi.png'))
    image_3 = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
    video = fixture_file_upload(Rails.root.join('spec/fixtures/joker.mp4'))
    user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01', files: [
                                pdf_1, image_1, image_2, image_3, video ])

    login_as user
    visit root_path
    click_on 'Meus Conteúdos'
    click_on 'Dev week'

    files = user.event_contents.last.files
    expect(page).to have_content('Dev week')
    expect(page).to have_content('Conteúdo da palestra de 01/01')
    expect(page).to have_css("img[src*='capi.png']")
    expect(page).to have_css("img[src*='puts.png']")
    expect(page).to have_css("img[src*='mark_zuckerberg.jpeg']")
    expect(page).to have_link('nota-ufjf.pdf', href: Rails.application.routes.url_helpers.rails_blob_path(files.first, only_path: true))
    expect(page).to have_css('video[controls][src*="joker.mp4"]')
  end

  it 'but is not authorized to view it for other users' do
    first_user = create(:user, first_name: 'João')
    event_content = first_user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    second_user = create(:user, first_name: 'Luiz')
    create(:profile, user: second_user)

    login_as second_user
    visit event_content_path(event_content)

    expect(current_path).to eq events_path
    expect(page).to have_content 'Conteúdo Indisponível!'
  end

  it 'must be authenticated' do
    user = create(:user, first_name: 'João')
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    visit event_content_path(event_content)

    expect(current_path).to eq new_user_session_path
  end

  it 'and view all tasks where this content is used' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    task = user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')
    EventTaskContent.create!(event_content: event_content, event_task: task)
    task2 = user.event_tasks.create!(name: 'Aprofundamento', description: 'pós créditos da palestra')
    EventTaskContent.create!(event_content: event_content, event_task: task2)

    login_as user
    visit event_content_path(event_content)

    expect(page).to have_content 'Tarefas que utilizam este conteúdo:'
    expect(page).to have_link 'Tarefa inicial'
    expect(page).to have_link 'Aprofundamento'
  end

  it 'and access task details' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')
    task = user.event_tasks.create!(name: 'Tarefa inicial', description: 'Desafio para iniciantes')
    EventTaskContent.create!(event_content: event_content, event_task: task)

    login_as user
    visit event_content_path(event_content)
    click_on 'Tarefa inicial'

    expect(current_path).to eq event_task_path(task)
  end

  it 'and not see tasks for this content' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    event_content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01')

    login_as user
    visit event_content_path(event_content)

    expect(page).to have_content 'Esse conteúdo não foi associado a nenhuma tarefa.'
  end
end
