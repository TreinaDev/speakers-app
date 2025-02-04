require 'rails_helper'

describe 'Curriculum API' do
  context 'GET /api/v1/curriculums/:schedule_item_code' do
    it 'with success' do
      user = create(:user)
      build(:event, name: 'Ruby on Rails')
      schedule_item = build(:schedule_item, id: 99, title: 'TDD com Rails', description: 'Introdução a programação com TDD')
      curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.id)
      files = [ fixture_file_upload(Rails.root.join('spec/fixtures/capi.png')),
                fixture_file_upload(Rails.root.join('spec/fixtures/nota-ufjf.pdf')),
                fixture_file_upload(Rails.root.join('spec/fixtures/joker.mp4')) ]
      first_content = user.event_contents.create(title: 'Ruby PDF', description: 'Descrição Ruby PDF',
                                                 external_video_url: 'https://www.youtube.com/watch?v=idaXF2Er4TU', files: files)
      second_content = user.event_contents.create(title: 'Ruby Video', description: 'Apresentação sobre TDD',
                                                 external_video_url: 'https://www.youtube.com/watch?v=2DvrRadXwWY')
      third_content = user.event_contents.create(title: 'Stimulus', description: 'PDF sobre Stimulus',
                                                 external_video_url: 'https://www.youtube.com/watch?v=1cw6qO1EYGw')
      first_curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: first_content)
      second_curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: second_content)
      create(:curriculum_content, curriculum: curriculum, event_content: third_content)
      first_task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)
      create(:curriculum_task, curriculum: curriculum, title: 'Exercício Stimulus', description: 'Seu primeiro exercício stimulus', certificate_requirement: :optional)
      create(:curriculum_task_content, curriculum_task: first_task, curriculum_content: first_curriculum_content)
      create(:curriculum_task_content, curriculum_task: first_task, curriculum_content: second_curriculum_content)

      allow(ScheduleItem).to receive(:find).and_return(schedule_item)


      get "/api/v1/curriculums/#{schedule_item.id}"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      curriculum_response = response.parsed_body['curriculum']
      tasks_response = curriculum_response['curriculum_tasks']
      contents_response = curriculum_response['curriculum_contents']
      expect(contents_response.length).to eq 3
      expect(contents_response[0]['title']).to eq 'Ruby PDF'
      expect(contents_response[0]['description']).to eq 'Descrição Ruby PDF'
      expect(contents_response[0]['external_video_url']).to eq 'https://www.youtube.com/watch?v=idaXF2Er4TU'
      p contents_response[0]
      expect(contents_response[0]['files'][0].filename).to eq 'capi.png'
      expect(contents_response[0]['files'][1].filename).to eq 'nota-ufjf.pdf'
      expect(contents_response[0]['files'][2].filename).to eq 'joker.mp4'
      expect(contents_response[1]['title']).to eq 'Ruby Video'
      expect(contents_response[1]['description']).to eq 'Apresentação sobre TDD'
      expect(contents_response[1]['external_video_url']).to eq 'https://www.youtube.com/watch?v=2DvrRadXwWY'
      expect(contents_response[2]['title']).to eq 'Stimulus'
      expect(contents_response[2]['description']).to eq 'PDF sobre Stimulus'
      expect(contents_response[2]['external_video_url']).to eq 'https://www.youtube.com/watch?v=1cw6qO1EYGw'


      expect(tasks_response.length).to eq 2
      #   expect(curriculum_response).to include(event.address)
      #   expect(curriculum_response).to include(event.description.body.to_html)
      #   expect(curriculum_response).to eq event.code
      #   expect(curriculum_response).to eq url_for(event.logo)
      #   expect(curriculum_response).to eq url_for(event.banner)
      #   expect(curriculum_response).to eq event.participants_limit
      #   expect(curriculum_response).to eq event.user.name
      #   expect(curriculum_response).to eq event.start_date.iso8601(3)
      #   expect(curriculum_response).to eq event.end_date.iso8601(3)
      #   expect(curriculum_response).not_to include(draft_event.name)
      #   expect(curriculum_response).not_to include(draft_event.address)
      #   expect(curriculum_response).not_to include(draft_event.description)
      #   expect(curriculum_response).not_to include(draft_event.id)
    end
  end
end
