require 'rails_helper'

describe 'POST /api/v1/participant_tasks' do
  it 'with success' do
    user = create(:user, id: 10)
    schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', code: '1234ABCD',
                   description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)

    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    post '/api/v1/participant_tasks', params: { participant_code: 'XLR8BEN1', task_code: '1234ABCD' }

    expect(response).to have_http_status :success
    expect(response.content_type).to include('application/json')
    json_response = JSON.parse(response.body)
    expect(json_response['message']).to eq('OK')
    expect(ParticipantRecord.count).to eq 1
    expect(ParticipantRecord.first.attributes.symbolize_keys).to match(a_hash_including(user_id: 10, participant_code: 'XLR8BEN1',
                                                                                        schedule_item_code: curriculum.schedule_item_code, enabled_certificate: false))

    expect(ParticipantTask.count).to eq 1
    expect(ParticipantTask.first.attributes.symbolize_keys).to match(a_hash_including(participant_record_id: ParticipantRecord.first.id, curriculum_task_id: task.id,
                                                                                      task_status: true))
  end

  it 'not found if task does not exist' do
    user = create(:user, id: 10)
    schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    create(:curriculum, user: user, schedule_item_code: schedule_item.code)

    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    post '/api/v1/participant_tasks', params: { participant_code: 'XLR8BEN1', task_code: 'ERROR_CODE' }

    expect(response).to have_http_status :not_found
    expect(response.content_type).to include('application/json')
    json_response = JSON.parse(response.body)
    expect(json_response['error']).to eq('Tarefa não encontrada.')
    expect(ParticipantRecord.count).to eq 0
    expect(ParticipantTask.count).to eq 0
  end

  it 'not found if participant does not exist' do
    user = create(:user, id: 10)
    schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', code: '1234ABCD',
            description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)

    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    post '/api/v1/participant_tasks', params: { participant_code: '', task_code: '1234ABCD' }

    expect(response).to have_http_status :not_found
    expect(response.content_type).to include('application/json')
    json_response = JSON.parse(response.body)
    expect(json_response['error']).to eq('Código do participante não pode ser em branco.')
    expect(ParticipantRecord.count).to eq 0
    expect(ParticipantTask.count).to eq 0
  end
end
