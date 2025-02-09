require 'rails_helper'

describe 'User validates certificate', type: :system do
  it 'with success' do
    user = create(:user, first_name: 'Otávio', last_name: 'Campus')
    participant = build(:participant, name: 'Erika', last_name: 'Campus', cpf: '548.966.630-71')
    event = build(:event, name: 'Ruby on Rails')
    schedule_item = build(:schedule_item, name: 'Palestra sobre TDD')
    certificate = create(:certificate,
      user: user,
      responsable_name: user.full_name,
      schedule_item_name: schedule_item.name,
      event_name: event.name,
      issue_date: Date.current,
      length: '60 minutos',
      token: 'H897E6JPN1KTR6BY4VOP',
      participant_name: Participant.full_name(participant.name, participant.last_name)
    )

    visit certificates_path

    fill_in 'search_certificate_input', with: 'H897E6JPN1KTR6BY4VOP'
    click_on 'Buscar'

    expect(current_path).to eq search_certificates_path
    expect(page).to have_content 'Certificado válido.'
    expect(page).to have_content "Aluno(a): Erika Campus"
    expect(page).to have_content "Evento: Ruby on Rails"
    expect(page).to have_content "Curso: Palestra sobre TDD"
    expect(page).to have_content "Instrutor(a): Otávio Campus"
    expect(page).to have_content "Duração: 60 minutos"
    expect(page).to have_content "Data de emissão: #{certificate.issue_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Código: H897E6JPN1KTR6BY4VOP"
    expect(page).to have_link "Faça o download"
  end

  it 'and certificate token is invalid' do
    create(:certificate, token: 'H897E6JPN1KTR6BY4VOP')

    visit certificates_path

    fill_in 'search_certificate_input', with: 'INVALIDCODE'
    click_on 'Buscar'

    expect(current_path).to eq certificates_path
    expect(page).to have_content 'Certificado não encontrado. Caso acredite que seja um erro, entre em contato com o responsável do evento.'
  end
end
