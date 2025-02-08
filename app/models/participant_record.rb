class ParticipantRecord < ApplicationRecord
  belongs_to :user
  has_many :participant_tasks

  validates :schedule_item_code, :participant_code, presence: true
  after_create :scheduling_for_certificate_creation

  private

  def scheduling_for_certificate_creation
    user = User.find(self.user.id)
    schedule_item = ScheduleItem.find(schedule_item_code: self.schedule_item_code, token: user.token)
    length = time_diff(schedule_item)
    event = Event.find(code: schedule_item.event_code, token: user.token)
    CertificateIssuanceJob.set(wait_until: event.end_date).perform_later(
      schedule_item_code: schedule_item.code, schedule_item_name: schedule_item.name,
      date_perfome: event.end_date, event_name: event.name, date_of_occurrence: schedule_item.date,
      length: length
    )
  end

  def time_diff(schedule_item)
    time_difference_in_seconds = schedule_item.end_time - schedule_item.start_time
    time_difference_in_minutes = (time_difference_in_seconds / 60).to_i
    hours = time_difference_in_minutes / 60
    minutes = time_difference_in_minutes % 60
    if hours > 0
      I18n.t('hour_minute_length', hours: hours, minutes: minutes)
    else
      I18n.t('minute_length', minutes: minutes)
    end
  end
end
