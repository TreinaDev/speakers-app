require 'rails_helper'

RSpec.describe EventContent, type: :model do
  context 'validations' do
    it { validate_presence_of(:title) }
    it { should_not validate_presence_of(:description) }
    it { should have_many_attached(:files) }
    it { should belong_to(:user) }
    it { should have_many(:event_task_contents) }
    it { should have_many(:event_tasks).through(:event_task_contents) }
  end

  context '.must_have_less_than_five_files' do
    it 'return error if more than five files' do
      user = create(:user)
      pdf_1 = fixture_file_upload(Rails.root.join('spec/fixtures/nota-ufjf.pdf'))
      pdf_2 = fixture_file_upload(Rails.root.join('spec/fixtures/nota-ufjf.pdf'))
      image_1 = fixture_file_upload(Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg'))
      image_2 = fixture_file_upload(Rails.root.join('spec/fixtures/capi.png'))
      image_3 = fixture_file_upload(Rails.root.join('spec/fixtures/puts.png'))
      video = fixture_file_upload(Rails.root.join('spec/fixtures/joker.mp4'))
      event_content = EventContent.new(user: user, title: 'Dev week', description: '', files: [
                                      pdf_1, pdf_2, image_1, image_2, image_3, video
                                    ])

      expect(event_content).not_to be_valid
    end
  end

  context '.valid_file_size' do
    it 'return error if file size is larger than 50mb' do
      user = create(:user)
      pdf = fixture_file_upload(Rails.root.join('spec/fixtures/Topicos de Fisica.pdf'))
      event_content = EventContent.new(user: user, title: 'Dev week', description: '', files: [ pdf ])

      expect(event_content).not_to be_valid
    end
  end

  context '.check_external_video_url' do
    it 'return error if external video url is not from youtube or vimeo' do
      user = create(:user)
      event_content = EventContent.new(user: user, title: 'Ruby para iniciantes', description: 'Seu primeiro contato com Ruby',
                                       external_video_url: 'https://app.campuscode.com.br/')

      expect(event_content).not_to be_valid
    end
  end
end
