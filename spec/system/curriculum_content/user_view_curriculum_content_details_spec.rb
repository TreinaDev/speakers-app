require 'rails_helper'

describe 'User access curriculum content details' do
  it 'with success' do
    user = create(:user)
    event =  [ build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
                  start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
                  event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado') ]
    schedule_items = [ build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD') ]
    image_1 = fixture_file_upload(Rails.root.join('spec/fixtures/capi.png'))
    image_2 = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
    content = user.event_contents.create(title: 'Arquivos TDD', description: 'Apresentação sobre TDD', files: [ image_1, image_2 ])
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_items.first.id)
    create(:curriculum_content, curriculum: curriculum, event_content: content)

    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedule_items)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)

    login_as user, scope: :user
    visit root_path
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'
    click_on 'Arquivos TDD'

    expect(page).to have_content 'Arquivos TDD'
    expect(page).to have_content 'Apresentação sobre TDD'
    expect(page).to have_css("img[src*='capi.png']")
    expect(page).to have_css("img[src*='puts.png']")
  end
end
