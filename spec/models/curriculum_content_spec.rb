require 'rails_helper'

RSpec.describe CurriculumContent, type: :model do
  context 'validations' do
    subject { create(:curriculum_content) }
    it { should validate_uniqueness_of(:curriculum_id).scoped_to(:event_content_id) }
    it { should belong_to(:curriculum) }
    it { should belong_to(:event_content) }
  end
end
