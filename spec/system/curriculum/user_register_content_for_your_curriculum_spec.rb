require 'rails_helper'

describe 'User register content for your schedule item curriculum' do
  it 'with success' do
    user = create(:user, id: 99)
    event =  [ build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
                  start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
                  event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado') ]
    schedule_items = [ build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD') ]
    user.event_contents.create(title: 'Introdução', description: 'Apresentação')
    user.event_contents.create(title: 'Desenvolvimento', description: 'Lógica de Programação')

    allow(Event).to receive(:all).and_return(event)
    allow(Event).to receive(:find).and_return(event.first)
    allow(event.first).to receive(:schedule_items).and_return(schedule_items)
    allow(ScheduleItem).to receive(:find).and_return(schedule_items.first)

    login_as user, scope: :user
    visit root_path
    click_on 'Ruby on Rails'
    click_on 'TDD com Rails'
    click_on 'Adicionar conteúdo'
    select 'Desenvolvimento', from: 'Conteúdos'
    click_on 'Adicionar'

    expect(CurriculumContent.count).to eq 1
    expect(current_path).to eq schedule_item_path(schedule_items.first.id)
    expect(page).to have_content 'Desenvolvimento'
  end
end
