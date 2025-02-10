require 'rails_helper'
require 'pdf-reader'

describe 'Participante sees your certificate' do
  it 'with success' do
    user = create(:user, first_name: 'Maria', last_name: 'Josefina')
    participant = build(:participant, name: 'João', last_name: 'Campus', cpf: '548.966.630-71')
    event = build(:event, name: 'Ruby on Rails', start_date: 7.days.ago, end_date: 1.day.ago)
    schedule_item = build(:schedule_item, name: 'Palestra sobre TDD', start_time: Time.now,
                          end_time: Time.now + 1.hour, date: 2.days.ago)

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
      participant_name: Participant.full_name(participant.name, participant.last_name),
      participant_register: participant.cpf
    )

    get "/certificates/#{certificate.token}.pdf"

    reader = PDF::Reader.new(StringIO.new(response.body))

    expect(reader.pages[0].text).to include('Certificado de Participação')
    expect(reader.pages[0].text).to include("Nome do Participante: João Campus")
    expect(reader.pages[0].text).to include("CPF: #{certificate.participant_register}")
    expect(reader.pages[0].text).to include("Evento: #{certificate.event_name}")
    expect(reader.pages[0].text).to include("Palestra: #{certificate.schedule_item_name} (Código: #{certificate.schedule_item_code})")
    expect(reader.pages[0].text).to include("Data da Palestra: #{certificate.date_of_occurrence.strftime('%d/%m/%Y')}")
    expect(reader.pages[0].text).to include("Duração: #{certificate.length}")
    expect(reader.pages[0].text).to include("Responsável: #{certificate.responsable_name}")
    expect(reader.pages[0].text).to include("Emitido em: #{certificate.issue_date.strftime('%d/%m/%Y')}")
    expect(reader.pages[0].text).to include("Código de Verificação: #{certificate.token}")
  end

  it 'and not found' do
    get "/certificates/something.pdf"

    expect(response).to redirect_to certificates_path
  end
end
