require 'rails_helper'

RSpec.describe ParticipantRecord, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should have_many(:participant_tasks) }
    it { should validate_presence_of(:participant_code) }
    it { should validate_presence_of(:schedule_item_code) }
  end

  context '.scheduling_for_certificate_creation' do
    it 'must queue a job' do
      schedule = Schedule.new(date: 1.day.from_now)
      schedule_item = build(:schedule_item)
      event = build(:event)
      user = create(:user)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      allow(Event).to receive(:find).and_return(event)

      participant_record = build(:participant_record, user: user)

      expect {
        participant_record.save
      }.to have_enqueued_job(CertificateIssuanceJob)
    end
  end

  context '.change_enabled_certificate' do
    it 'with success' do
      user = create(:user)
      event = build(:event)
      schedule_item = build(:schedule_item)
      curriculum = create(:curriculum, user: user, schedule_item_code: schedule_item.code)
      task = create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails',
                   description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)
      allow(Event).to receive(:find).and_return(event)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      record = create(:participant_record, user: user, enabled_certificate: false, schedule_item_code: schedule_item.code)
      participant_task = build(:participant_task, participant_record: record, curriculum_task: task, task_status: true)

      record.change_enabled_certificate(curriculum, participant_task)

      expect(record.enabled_certificate).to eq(true)
    end

    it 'with curriculum and participant_task nil' do
      user = create(:user)
      curriculum = nil
      event = build(:event)
      schedule_item = build(:schedule_item)
      allow(Event).to receive(:find).and_return(event)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item)
      record = create(:participant_record, user: user, enabled_certificate: false)
      participant_task = nil

      record.change_enabled_certificate(curriculum, participant_task)

      expect(record.enabled_certificate).to eq(false)
    end
  end
end
