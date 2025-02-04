require 'rails_helper'

RSpec.describe CurriculumContent, type: :model do
  let!(:user) { create(:user) }
  let!(:event_content) { create(:event_content, user: user) }
  let!(:curriculum) { create(:curriculum, user: user, schedule_item_code: 99) }

  context 'validations' do
    subject { create(:curriculum_content, curriculum: curriculum, event_content: event_content) }
    it { should validate_uniqueness_of(:curriculum_id).scoped_to(:event_content_id) }
    it { should belong_to(:curriculum) }
    it { should belong_to(:event_content) }
    it { should have_many(:curriculum_task_contents) }
    it { should have_many(:curriculum_tasks).through(:curriculum_task_contents) }
    it { validate_presence_of(:code) }
    it { validate_uniqueness_of(:code) }
  end

  context '.must_be_event_content_owner' do
    it 'return error if not event content owner' do
      first_user = create(:user)
      first_user_event_content = create(:event_content, id: 11, user: first_user)
      second_user = create(:user)
      curriculum = create(:curriculum, user: second_user, schedule_item_code: 99)
      curriculum_content = CurriculumContent.new(curriculum: curriculum, event_content: first_user_event_content)

      expect(curriculum_content).not_to be_valid
    end
  end

  context '.title' do
    it 'must return the event content title' do
      user = create(:user)
      event_content = create(:event_content, title: 'Conteudo teste', user: user)
      curriculum = create(:curriculum, user: user)
      curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: event_content)

      expect(curriculum_content.title).to eq 'Conteudo teste'
    end
  end

  context '.to_param' do
    it 'must return the curriculum_content.code' do
      user = create(:user)
      event_content = create(:event_content, title: 'Conteudo teste', user: user)
      curriculum = create(:curriculum, user: user)
      curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: event_content, code: 'ABCDE')

      expect(curriculum_content.to_param).to eq 'ABCDE'
    end
  end

  context '.generate_code' do
    it 'must return an unique code' do
      user = create(:user)
      event_content = create(:event_content, title: 'Conteudo teste', user: user)
      curriculum = create(:curriculum, user: user)
      second_curriculum = create(:curriculum, user: user)
      first_curriculum_content = create(:curriculum_content, curriculum: curriculum, event_content: event_content)
      second_curriculum_content = create(:curriculum_content, curriculum: second_curriculum, event_content: event_content)

      expect(first_curriculum_content.code).not_to eq second_curriculum_content.code
    end
  end
end
