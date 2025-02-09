require 'rails_helper'

describe 'Participant requests certificate', type: :request do
  it 'must return the existing certificate' do
    user = create(:user, first_name: 'João', last_name: 'Almeida')
    participant = build(:participant)
    event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
    schedule_item = build(:schedule_item, name: 'TDD com RSpec e Capybara', date: 2.days.ago, start_time: '15:00', end_time: '17:00')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    allow(Event).to receive(:find).and_return(event)
    allow(Participant).to receive(:find).and_return(participant)
    participant_record = create(:participant_record, user: user, participant_code: 'ABC123', schedule_item_code: schedule_item.code, enabled_certificate: true)
    certificate = create(:certificate, user: user, speaker_code: user.token, schedule_item_name: schedule_item.name, event_name: event.name,
                         date_of_occurrence: schedule_item.date, issue_date: event.end_date, length: '2:00 h', participant_code: participant_record.participant_code,
                         schedule_item_code: schedule_item.code)

    get api_v1_curriculum_certificate_path(curriculum_schedule_item_code: schedule_item.code, participant_code: participant_record.participant_code)

    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(response).to have_http_status :ok
    expect(json_response['certificate_url']).to eq certificate_pdf_url(certificate.token)
  end

  it 'should create and return a new certificate if it does not exist' do
    user = create(:user, first_name: 'João', last_name: 'Almeida')
    participant = build(:participant)
    event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
    schedule_item = build(:schedule_item, name: 'TDD com RSpec e Capybara', date: 2.days.ago, start_time: '15:00', end_time: '17:00')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    allow(Event).to receive(:find).and_return(event)
    allow(Participant).to receive(:find).and_return(participant)
    participant_record = create(:participant_record, user: user, participant_code: 'ABC123', schedule_item_code: schedule_item.code, enabled_certificate: false)

    get api_v1_curriculum_certificate_path(curriculum_schedule_item_code: schedule_item.code, participant_code: participant_record.participant_code)

    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(response).to have_http_status :ok
    expect(json_response['certificate_url']).to eq certificate_pdf_url(Certificate.last.token)
  end

  it 'must not return a certificate if the participant is not found' do
    user = create(:user, first_name: 'João', last_name: 'Almeida')
    participant = build(:participant)
    event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
    schedule_item = build(:schedule_item, name: 'TDD com RSpec e Capybara', date: 2.days.ago, start_time: '15:00', end_time: '17:00')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    allow(Event).to receive(:find).and_return(event)
    allow(Participant).to receive(:find).and_return(participant)
    participant_record = create(:participant_record, user: user, participant_code: 'ABC123', schedule_item_code: schedule_item.code, enabled_certificate: true)

    get api_v1_curriculum_certificate_path(curriculum_schedule_item_code: schedule_item.code, participant_code: 'Something')

    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(response).to have_http_status :not_found
    expect(json_response['error']).to eq 'Certificado não encontrado!'
  end

  it 'must not return a certificate if the schedule item is not found' do
    user = create(:user, first_name: 'João', last_name: 'Almeida')
    participant = build(:participant)
    event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
    schedule_item = build(:schedule_item, name: 'TDD com RSpec e Capybara', date: 2.days.ago, start_time: '15:00', end_time: '17:00')
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    allow(Event).to receive(:find).and_return(event)
    allow(Participant).to receive(:find).and_return(participant)
    participant_record = create(:participant_record, user: user, participant_code: 'ABC123', schedule_item_code: schedule_item.code, enabled_certificate: true)

    get api_v1_curriculum_certificate_path(curriculum_schedule_item_code: 'Something', participant_code: participant_record.participant_code)

    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(response).to have_http_status :not_found
    expect(json_response['error']).to eq 'Certificado não encontrado!'
  end

  it 'failure with an internal error' do
    allow(ParticipantRecord). to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
    get api_v1_curriculum_certificate_path(curriculum_schedule_item_code: 'Something', participant_code: 'Something')

    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(response).to have_http_status :internal_server_error
    expect(response.parsed_body['error']).to eq 'Algo deu errado.'
  end
end
