class Certificate < ApplicationRecord
  belongs_to :user
  after_initialize :generate_token, if: :new_record?
  validates :responsable_name, :speaker_code, :event_name, :date_of_occurrence, :issue_date, :length, :token, :participant_code, :schedule_item_code, presence: true
  validates :token, uniqueness: true

  def self.time_diff(schedule_item)
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

  private

  def generate_token
    loop do
      self.token = SecureRandom.alphanumeric(20)
      break unless Certificate.exists?(token: self.token)
    end
  end
end
