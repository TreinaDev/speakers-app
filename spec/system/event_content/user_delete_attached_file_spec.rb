require 'rails_helper'

describe 'User delete attached file', type: :system do
  it 'with sucess' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    files = [ Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'),
              Rails.root.join('spec/fixtures/capi.png'),
              Rails.root.join('spec/fixtures/puts.png')
            ]
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01', files: files)

    login_as user
    visit edit_event_content_path(content)
    uncheck 'check_box_mark_zuckerberg.jpeg'
    click_on 'Atualizar Conteúdo'

    expect(current_path).to eq event_content_path(content)
    expect(user.event_contents.first.files.count).to eq 2
    expect(page).to have_css("img[src*='capi.png']")
    expect(page).to have_css("img[src*='puts.png']")
    expect(page).not_to have_css("img[src*='mark_zuckerberg.jpeg']")
  end

  it 'from event content details page' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)
    files = [ Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'),
              Rails.root.join('spec/fixtures/capi.png'),
              Rails.root.join('spec/fixtures/puts.png')
            ]
    content = user.event_contents.create!(title: 'Dev week', description: 'Conteúdo da palestra de 01/01', files: files)

    login_as user
    visit event_content_path(content)
    all('.button_to button', text: '✖').first.click

    expect(user.event_contents.first.files.count).to eq 2
    expect(page).to have_css("img[src*='capi.png']")
    expect(page).to have_css("img[src*='puts.png']")
    expect(page).not_to have_css("img[src*='mark_zuckerberg.jpeg']")
  end
end
