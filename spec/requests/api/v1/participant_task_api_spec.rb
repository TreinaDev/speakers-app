require 'rails_helper'

describe 'POST /api/v1/blabla' do
  it 'with success' do
    user = create(:user)
    schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD')
    curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
    task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', code: '1234ABCD',
                   description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)

    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    post '/api/v1/participant_tasks', params: { participant_code: 'código',  schedule_item_code: 'ABCD1234', task_code: '1234ABCD' }

    expect(response).to have_http_status :success
    expect(response.content_type).to include('application/json')
    json_response = JSON.parse(response.body)
    expect(json_response["participant_record"].deep_symbolyze_keys).to eq({ participant_code: 'código', speaker_id: user.id, schedule_item_code: 'ABCD1234', enebled_certificate: false })
    expect(json_response["participant_task"].deep_symbolyze_keys).to eq({ participant_record_id: 1,  task_code: '1234ABCD', task_status: false })
  end
end
