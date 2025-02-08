require 'rails_helper'

RSpec.describe ParticipantRecord, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should have_many(:participant_tasks) }
    it { should validate_presence_of(:participant_code) }
    it { should validate_presence_of(:schedule_item_code) }
  end

  context '.change_enabled_certificate' do
    it 'with success' do
      user = create(:user)
      curriculum = create(:curriculum, user: user)
      task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails',
                   description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)
      record = create(:participant_record, user: user, enabled_certificate: false)
      participant_task = build(:participant_task, participant_record: record, curriculum_task: task, task_status: true)

      record.change_enabled_certificate(curriculum, participant_task)

      expect(record.enabled_certificate).to eq(true)
    end

    it 'with curriculum and participant_task nil' do
      user = create(:user)
      curriculum = nil
      record = create(:participant_record, user: user, enabled_certificate: false)
      participant_task = nil

      record.change_enabled_certificate(curriculum, participant_task)

      expect(record.enabled_certificate).to eq(false)
    end
  end
end
