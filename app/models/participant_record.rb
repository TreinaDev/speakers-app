class ParticipantRecord < ApplicationRecord
  belongs_to :user
  has_many :participant_tasks

  validates :schedule_item_code, :participant_code, presence: true
  after_create :scheduling_for_certificate_creation

  private

  def scheduling_for_certificate_creation
    user = User.find(self.user.id)
    schedule_item = ScheduleItem.find(schedule_item_code: self.schedule_item_code, token: user.token)
    length = Certificate.time_diff(schedule_item)
    event = Event.find(code: schedule_item.event_code, token: user.token)
    CertificateIssuanceJob.set(wait_until: event.end_date).perform_later(
      schedule_item_code: schedule_item.code, schedule_item_name: schedule_item.name,
      date_perfome: event.end_date, event_name: event.name, date_of_occurrence: schedule_item.date,
      length: length
    )
  end
end
