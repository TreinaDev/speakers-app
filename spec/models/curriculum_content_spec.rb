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
end
