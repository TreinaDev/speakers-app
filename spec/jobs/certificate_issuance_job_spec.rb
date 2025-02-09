require 'rails_helper'

RSpec.describe CertificateIssuanceJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers
  it 'should be automatically queued when participant records are created' do
    schedule = Schedule.new(date: 1.day.from_now)
    schedule_item = build(:schedule_item)
    event = build(:event)
    user = create(:user)
    participant = build(:participant)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    allow(Event).to receive(:find).and_return(event)
    allow(Participant).to receive(:find).and_return(participant)

    participant_record = create(:participant_record, user: user, enabled_certificate: true, schedule_item_code: schedule_item.code)

    expect(enqueued_jobs.size).to eq(1)
  end

  it 'should automatically create certificates when the issuance date arrives' do
    schedule = Schedule.new(date: 1.day.from_now)
    schedule_item = build(:schedule_item, date: schedule.date)
    event = build(:event)
    user = create(:user)
    participant = build(:participant)
    allow(ScheduleItem).to receive(:find).and_return(schedule_item)
    allow(Event).to receive(:find).and_return(event)
    allow(Participant).to receive(:find).and_return(participant)

    participant_record = create(:participant_record, user: user, enabled_certificate: true, schedule_item_code: schedule_item.code)
    perform_enqueued_jobs

    expect(Certificate.count).to eq 1
  end
end
