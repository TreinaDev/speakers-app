require 'rails_helper'

describe 'Curriculum API' do
  context 'GET /api/v1/curriculums/:schedule_item_code' do
    it 'with success' do
      user = create(:user)
      event = build(:event)
      build(:participant, code: 'XLR9BEN4')
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: 7.days.ago)
      curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      files = [ fixture_file_upload(Rails.root.join('spec/fixtures/capi.png')),
                fixture_file_upload(Rails.root.join('spec/fixtures/nota-ufjf.pdf')),
                fixture_file_upload(Rails.root.join('spec/fixtures/joker.mp4')) ]
      first_content = create(:event_content, title: 'Ruby PDF', description: '<strong>Descrição Ruby PDF</strong>',
                              external_video_url: 'https://www.youtube.com/watch?v=idaXF2Er4TU', files: files, user: user)
      create(:update_history, event_content: first_content, creation_date: Date.current)
      second_content = create(:event_content, title: 'Ruby Video', description: 'Apresentação sobre TDD',
                              external_video_url: 'https://www.youtube.com/watch?v=2DvrRadXwWY', user: user)
      third_content = create(:event_content, title: 'Stimulus', description: 'PDF sobre Stimulus',
                              external_video_url: 'https://www.youtube.com/watch?v=1cw6qO1EYGw', user: user)
      first_curriculum_content = create(:curriculum_content, id: 1, curriculum: curriculum, event_content: first_content, code: 'XLR8BE10')
      second_curriculum_content = create(:curriculum_content, id: 2, curriculum: curriculum, event_content: second_content, code: 'CODIGO15')
      create(:curriculum_content, curriculum: curriculum, event_content: third_content, code: 'CODIGO26')
      first_task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory, code: 'CODIGO37')
      create(:curriculum_task, curriculum: curriculum, title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus', certificate_requirement: :optional, code: 'CODIGO48')
      create(:curriculum_task_content, curriculum_task: first_task, curriculum_content: first_curriculum_content)
      create(:curriculum_task_content, curriculum_task: first_task, curriculum_content: second_curriculum_content)

      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Event).to receive(:find).and_return(event)
      get "/api/v1/curriculums/ABCD1234/participants/XLR9BEN4"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')

      curriculum_response = response.parsed_body['curriculum']
      tasks_response = curriculum_response['curriculum_tasks']
      contents_response = curriculum_response['curriculum_contents']
      expect(contents_response.length).to eq 3
      download_url_1 = rails_blob_url(first_content.files[0])
      download_url_2 = rails_blob_url(first_content.files[1])
      download_url_3 = rails_blob_url(first_content.files[2])
      expect(contents_response[0].deep_symbolize_keys).to include({ code: 'XLR8BE10', last_update: Date.current.strftime('%d/%m/%Y'), title: 'Ruby PDF', description: '<strong>Descrição Ruby PDF</strong>',
                                                                    external_video_url: "<iframe id='external-video' width='1000' height='600' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen class='rounded-3xl max-w-full'></iframe>",
                                                                    files: [ { file_download_url: download_url_1, filename: 'capi.png' },
                                                                             { file_download_url: download_url_2, filename: 'nota-ufjf.pdf' },
                                                                             { file_download_url: download_url_3, filename: 'joker.mp4' } ] })
      expect(contents_response[1].deep_symbolize_keys).to eq({ code: 'CODIGO15', title: 'Ruby Video', description: 'Apresentação sobre TDD',
                                                               external_video_url: "<iframe id='external-video' width='1000' height='600' src='https://www.youtube.com/embed/2DvrRadXwWY' frameborder='0' allowfullscreen class='rounded-3xl max-w-full'></iframe>" })
      expect(contents_response[2].deep_symbolize_keys).to eq({ code: 'CODIGO26', title: 'Stimulus', description: 'PDF sobre Stimulus',
                                                               external_video_url: "<iframe id='external-video' width='1000' height='600' src='https://www.youtube.com/embed/1cw6qO1EYGw' frameborder='0' allowfullscreen class='rounded-3xl max-w-full'></iframe>" })
      expect(tasks_response.length).to eq 2
      expect(tasks_response[0].deep_symbolize_keys).to eq({ code: 'CODIGO37', title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: 'Obrigatória',
                                                            attached_contents: [ { attached_content_code: 'XLR8BE10' }, { attached_content_code: 'CODIGO15' } ], task_status: false })
      expect(tasks_response[1].deep_symbolize_keys).to eq({ code: 'CODIGO48', title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus',
                                                            certificate_requirement: 'Opcional', task_status: false })
    end

    it 'with a schedule item that does not exist' do
      get "/api/v1/curriculums/EURTHUEI/participants/ABCETFUF"

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['error']).to eq 'Currículo não encontrado!'
    end

    it 'internal server error' do
      user = create(:user)
      schedule_item = build(:schedule_item, code: 99, name: 'TDD com Rails', description: 'Introdução a programação com TDD')
      create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      user.event_contents.create(title: 'Ruby PDF')

      allow(Curriculum).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get "/api/v1/curriculums/#{schedule_item.code}/participants/ABCETFUF"

      expect(response).to have_http_status :internal_server_error
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['error']).to eq 'Algo deu errado.'
    end

    it 'and tasks are not displayed before the event starts' do
      user = create(:user)
      event = build(:event)
      schedule_item = build(:schedule_item, name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: 1.days.from_now)
      curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      first_content = create(:event_content, user: user, title: 'Ruby para iniciantes', code: 'ABCD1234')
      first_curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: first_content, code: 'XLR8BEN1')
      first_task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)
      create(:curriculum_task, curriculum: curriculum, title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus', certificate_requirement: :optional)
      create(:curriculum_task_content, curriculum_task: first_task, curriculum_content: first_curriculum_content)

      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Event).to receive(:find).and_return(event)
      get "/api/v1/curriculums/#{schedule_item.code}/participants/ABCETFUF"

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      tasks_response = json_response['curriculum']['curriculum_tasks']
      expect(tasks_response.length).to eq 2
      expect(json_response['curriculum']['tasks_available']).to eq false
      expect(tasks_response[0].deep_symbolize_keys).to eq({ title: 'Exercício Rails' })
      expect(tasks_response[1].deep_symbolize_keys).to eq({ title: 'Exercício Stimulus' })
    end

    it 'and task_status is true for a participant' do
      user = create(:user)
      event = build(:event)
      participant = build(:participant)
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: Date.current)
      curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      first_task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory, code: 'CODIGO37')
      create(:curriculum_task, curriculum: curriculum, title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus', certificate_requirement: :optional, code: 'CODIGO48')
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Event).to receive(:find).and_return(event)
      allow(Participant).to receive(:find).and_return(participant)
      participant_record = create(:participant_record, user: user, participant_code: 'XLR9BEN4', schedule_item_code: 'ABCD1234')
      create(:participant_task, participant_record: participant_record, curriculum_task: first_task)

      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      get "/api/v1/curriculums/#{schedule_item.code}/participants/XLR9BEN4"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      curriculum_response = response.parsed_body['curriculum']
      tasks_response = curriculum_response['curriculum_tasks']
      expect(tasks_response.length).to eq 2
      expect(tasks_response[0].deep_symbolize_keys).to eq({ code: 'CODIGO37', title: 'Exercício Rails', description: 'Seu primeiro exercício ruby',
                                                            certificate_requirement: 'Obrigatória', task_status: true })
      expect(tasks_response[1].deep_symbolize_keys).to eq({ code: 'CODIGO48', title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus',
                                                            certificate_requirement: 'Opcional', task_status: false })
    end

    it 'and task_status is false for a second participant' do
      event = build(:event)
      user = create(:user)
      participant = build(:participant)
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: Date.current)
      curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      first_task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory, code: 'CODIGO37')
      create(:curriculum_task, curriculum: curriculum, title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus', certificate_requirement: :optional, code: 'CODIGO48')
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Event).to receive(:find).and_return(event)
      allow(Participant).to receive(:find).and_return(participant)
      participant_record = create(:participant_record, user: user, participant_code: 'XLR9BEN4', schedule_item_code: 'ABCD1234')
      create(:participant_task, participant_record: participant_record, curriculum_task: first_task)
      participant_record = create(:participant_record, user: user, participant_code: 'SEMTASK9', schedule_item_code: 'ABCD1234')

      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      get "/api/v1/curriculums/#{schedule_item.code}/participants/SEMTASK9"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      curriculum_response = response.parsed_body['curriculum']
      tasks_response = curriculum_response['curriculum_tasks']
      expect(tasks_response.length).to eq 2
      expect(tasks_response[0].deep_symbolize_keys).to eq({ code: 'CODIGO37', title: 'Exercício Rails', description: 'Seu primeiro exercício ruby',
                                                            certificate_requirement: 'Obrigatória', task_status: false })
      expect(tasks_response[1].deep_symbolize_keys).to eq({ code: 'CODIGO48', title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus',
                                                            certificate_requirement: 'Opcional', task_status: false })
    end

    it 'and certificate pdf url is listed if available' do
      user = create(:user)
      event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
      participant = build(:participant, code: 'XLR9BEN4')
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: 7.days.ago)
      create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      allow(Event).to receive(:find).and_return(event)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Participant).to receive(:find).and_return(participant)
      create(:participant_record, user: user, participant_code: 'XLR9BEN4', schedule_item_code: 'ABCD1234', enabled_certificate: true)
      create(:certificate, schedule_item_code: 'ABCD1234', participant_code: 'XLR9BEN4', token: 'PIMZBVXM04DWVNVWI90H')

      get "/api/v1/curriculums/ABCD1234/participants/XLR9BEN4"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['curriculum']['certificate_url']).to eq "http://www.example.com/certificates/PIMZBVXM04DWVNVWI90H.pdf"
    end

    it 'and certificate pdf is create and listed' do
      user = create(:user)
      event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
      participant = build(:participant, code: 'XLR9BEN4', name: 'Júlio', last_name: 'Almeida')
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: 7.days.ago)
      create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      allow(Event).to receive(:find).and_return(event)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Participant).to receive(:find).and_return(participant)
      create(:participant_record, user: user, participant_code: 'XLR9BEN4', schedule_item_code: 'ABCD1234', enabled_certificate: true)

      get "/api/v1/curriculums/ABCD1234/participants/XLR9BEN4"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(Certificate.count).to eq 1
      certificate = Certificate.last
      json_response = JSON.parse(response.body)
      expect(json_response['curriculum']['certificate_url']).to eq "http://www.example.com/certificates/#{ certificate.token }.pdf"
      expect(certificate.participant_name).to eq 'Júlio Almeida'
      expect(certificate.participant_code).to eq 'XLR9BEN4'
      expect(certificate.schedule_item_code).to eq 'ABCD1234'
    end

    it 'and certificate pdf url not is listed if event ongoing' do
      user = create(:user)
      event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.from_now)
      participant = build(:participant, code: 'XLR9BEN4')
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: 7.days.ago)
      create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      allow(Event).to receive(:find).and_return(event)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Participant).to receive(:find).and_return(participant)
      create(:participant_record, user: user, participant_code: 'XLR9BEN4', schedule_item_code: 'ABCD1234', enabled_certificate: true)

      get "/api/v1/curriculums/ABCD1234/participants/XLR9BEN4"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(Certificate.count).to eq 0
      json_response = JSON.parse(response.body)
      expect(json_response['curriculum'].deep_symbolize_keys).to eq({ tasks_available: true, curriculum_tasks: [], curriculum_contents: [] })
    end

    it 'and certificate pdf url is not listed if unavailable' do
      user = create(:user)
      event = build(:event, name: 'Dev Week', start_date: 7.days.ago, end_date: 1.day.ago)
      participant = build(:participant, code: 'XLR9BEN4')
      schedule_item = build(:schedule_item, code: 'ABCD1234', name: 'TDD com Rails', description: 'Introdução a programação com TDD', event_start_date: 7.days.ago)
      create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      allow(Event).to receive(:find).and_return(event)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Participant).to receive(:find).and_return(participant)
      create(:participant_record, user: user, participant_code: 'XLR9BEN4', schedule_item_code: 'ABCD1234', enabled_certificate: false)

      get "/api/v1/curriculums/ABCD1234/participants/XLR9BEN4"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['curriculum'].deep_symbolize_keys).to eq({ tasks_available: true, curriculum_tasks: [], curriculum_contents: [] })
    end
  end
end
