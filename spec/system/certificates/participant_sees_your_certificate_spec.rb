require 'rails_helper'

describe 'Participante sees your certificate' do
  it 'with success' do
    user = create(:user, first_name: 'Maria', last_name: 'Josefina')
    participant = build(:participant, name: 'João', last_name: 'Campus', cpf: '548.966.630-71')
    event = build(:event, name: 'Ruby on Rails', start_date: 7.days.ago, end_date: 1.day.ago)
    schedule_item = build(:schedule_item, name: 'Palestra sobre TDD', start_time: Time.now,
                          end_time: Time.now + 1.hour, date: 2.days.ago)
    user = create(:user, first_name: 'Maria', last_name: 'Josefina')
    
    certificate = create(:certificate,
      user: user,
      responsable_name: user.full_name,
      speaker_code: user.token,
      schedule_item_name: schedule_item.name,
      schedule_item_code: schedule_item.code,
      event_name: event.name,
      date_of_occurrence: schedule_item.date,
      issue_date: Date.current,
      participant_code: participant.code,
      length: '60 minutos',
      token: SecureRandom.alphanumeric(20).upcase,
      participant_name: participant.name,
      participant_register: participant.cpf
    )
    
    visit certificate_path(certificate.token)

    expect(rendered).to have_content('Certificado de Participação')
    expect(rendered).to have_content("Nome do Participante: João Campus")
    expect(rendered).to have_content("Registro: #{certificate.participant_register}")
    expect(rendered).to have_content("Evento: #{certificate.event_name}")
    expect(rendered).to have_content("Atividade: #{certificate.schedule_item_name} (Código: #{certificate.schedule_item_code})")
    expect(rendered).to have_content("Data da Palestra: #{certificate.date_of_occurrence.strftime('%d/%m/%Y')}")
    expect(rendered).to have_content("Duração: #{certificate.length}")
    expect(rendered).to have_content("Responsável: #{certificate.responsable_name}")
    expect(rendered).to have_content("Emitido em: #{certificate.issue_date.strftime('%d/%m/%Y')}")
    expect(rendered).to have_content("Código de Verificação: #{certificate.token}")
  end
end