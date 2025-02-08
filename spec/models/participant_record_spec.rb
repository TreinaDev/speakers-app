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
end
