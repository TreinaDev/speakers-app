require 'rails_helper'

describe 'User views the public profile', type: :system do
  it 'with success' do
    events = [ build(:event, name: 'Event1',
                             url: '',
                             description: 'Event1 description',
                             start_date: '14-01-2025',
                             end_date: '16-01-2025',
                             event_type: 'in-person',
                             address: 'Palhoça',
                             participants_limit: 20,
                             status: 'published'),
               build(:event, name: 'Event2',
                             url: '',
                             description: 'Event2 description',
                             start_date: '15-01-2025',
                             end_date: '17-01-2025',
                             event_type: 'in-person',
                             address: 'Florianópolis',
                             participants_limit: 20,
                             status: 'draft') ]
    allow(Event).to receive(:all).and_return(events)
    user = create(:user, first_name: 'José', last_name: 'de Jesus')
    image = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
    profile = create(:profile, title: 'Instrutor', about_me: 'Olá, meu nome é José e eu sou um instrutor de Ruby on Rails',
                     user: user, profile_picture: image, pronoun: 'Ele/Dele', city: 'Florianópolis', birth: '1999-01-02', gender: 'Masculino')
    create(:social_network, url: 'https://www.youtube.com/@JoséTutoriais', social_network_type: 1, profile: profile)
    create(:social_network, url: 'https://www.josetutoriais.com/', social_network_type: :my_site, profile: profile)
    create(:social_network, url: 'https://x.com/jose', social_network_type: :x, profile: profile)
    create(:social_network, url: 'https://github.com/josedejesus', social_network_type: :github, profile: profile)
    create(:social_network, url: 'https://www.facebook.com/josedejesus', social_network_type: :facebook, profile: profile)

    visit profile_path(profile.username)

    expect(page).to have_content('José de Jesus')
    expect(page).to have_content('Instrutor')
    expect(page).to have_content('Olá, meu nome é José e eu sou um instrutor de Ruby on Rails')
    expect(page).to have_content('Ele/Dele')
    expect(page).to have_content('Florianópolis')
    expect(page).to have_content('02/01/1999')
    expect(page).to have_content('Masculino')
    expect(page).to have_css("img[src*='puts.png']")
    expect(page).to have_link('Youtube')
    expect(page).to have_link('Meu Site')
    expect(page).to have_link('X')
    expect(page).to have_link('GitHub')
    expect(page).to have_link('Facebook')
    expect(page).to have_content('Meus Eventos (2)')
    expect(page).to have_content('Event1')
    expect(page).to have_content('Event2')
  end

  it 'as owner' do
    user = create(:user, first_name: 'José', last_name: 'de Jesus')
    image = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
    profile = create(:profile, title: 'Instrutor', about_me: 'Olá, meu nome é José e eu sou um instrutor de Ruby on Rails',
                     user: user, profile_picture: image, pronoun: 'Ele/Dele', city: 'Florianópolis', birth: '1999-01-02', gender: 'Masculino')
    create(:social_network, profile: profile)

    login_as user
    visit events_path
    click_on 'José de Jesus'
    click_on 'Meu Perfil'

    expect(page).to have_content('José de Jesus')
    expect(page).to have_content('Instrutor')
    expect(page).to have_content('Olá, meu nome é José e eu sou um instrutor de Ruby on Rails')
    expect(page).to have_css("img[src*='puts.png']")
    expect(page).to have_link('Youtube')
  end

  it 'that does not exist' do
    visit profile_path('Thiago')

    expect(current_path).to eq(root_path)
    expect(page).to have_content('O usuário Thiago não existe.')
  end

  it 'that does not exist. (Authenticated user)' do
    user = create(:user, first_name: 'João')
    create(:profile, user: user)

    login_as user
    visit profile_path('Thiago')

    expect(current_path).to eq(events_path)
    expect(page).to have_content('O usuário Thiago não existe.')
  end

  it 'and set private fields' do
    user = create(:user, first_name: 'José', last_name: 'de Jesus')
    image = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
    create(:profile, title: 'Instrutor', about_me: 'Olá, meu nome é José e eu sou um instrutor de Ruby on Rails',
                     user: user, profile_picture: image, pronoun: 'Ele/Dele', city: 'Florianópolis', birth: '1999-01-02', gender: 'Masculino',
                     display_gender: false, display_pronoun: false, display_city: false, display_birth: false)

    login_as user
    visit events_path
    click_on 'José de Jesus'
    click_on 'Meu Perfil'

    expect(page).not_to have_content('Pronomes')
    expect(page).not_to have_content('Ele/Dele')
    expect(page).not_to have_content('Cidade')
    expect(page).not_to have_content('Florianópolis')
    expect(page).not_to have_content('Birth')
    expect(page).not_to have_content('02/01/1999')
    expect(page).not_to have_content('Gênero')
    expect(page).not_to have_content('Masculino')
  end
end
