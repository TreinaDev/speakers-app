require 'rails_helper'

RSpec.describe CurriculumTask, type: :model do
  context 'validations' do
    it { validate_presence_of(:title) }
    it { validate_presence_of(:description) }
    it { validate_presence_of(:certificate_requirement) }
    it { should belong_to(:curriculum) }
    it { should define_enum_for(:certificate_requirement).with_values(mandatory: 1, optional: 0) }
    it { should define_enum_for(:certificate_requirement).with_default(:optional) }
    subject { create(:curriculum_task) }
    it { validate_uniqueness_of(:title).scoped_to(:curriculum_id) }
    it { should have_many(:curriculum_task_contents) }
    it { should have_many(:curriculum_contents).through(:curriculum_task_contents) }
    it { validate_presence_of(:code) }
    it { validate_uniqueness_of(:code) }
  end

  context '.to_param' do
    it 'must return the curriculum_task.code' do
      curriculum_task = create(:curriculum_task, code: 'ABCDE')

      expect(curriculum_task.to_param).to eq 'ABCDE'
    end
  end

  context '.generate_code' do
    it 'must return an unique code' do
      first_curriculum_task = create(:curriculum_task)
      second_curriculum_task = create(:curriculum_task)

      expect(first_curriculum_task.code).not_to eq second_curriculum_task.code
    end
  end
end
