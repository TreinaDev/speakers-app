class ScheduleItem
  extend ActiveModel::Translation

  attr_accessor :id, :title, :speaker_email, :description, :length, :start_time
  @@instances = []
  def initialize(id:, title:, speaker_email:, description:, length:, start_time:)
    @id = id
    @title = title
    @speaker_email = speaker_email
    @description = description
    @length = length
    @start_time = start_time
    @@instances << self
  end

  def self.find(schedule_item_id:, email:)
    ExternalEventApi::FindScheduleItemService.call(email: email, schedule_item_id: schedule_item_id)
  end

  def self.count
    @@instances.size
  end

  def self.delete_all
    @@instances = []
  end

  def participants
    ExternalParticipantApi::ListParticipantsService.call(schedule_item_id: id)
  end
end
