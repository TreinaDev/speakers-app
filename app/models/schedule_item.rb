class ScheduleItem < ApplicationModel
  attr_accessor :id, :title, :speaker_email, :description, :length
  @@instances = []
  def initialize(id:, title:, speaker_email:, description:, length:)
    @id = id
    @title = title
    @speaker_email = speaker_email
    @description = description
    @length = length
    @@instances << self
  end

  def self.find(schedule_item_id:, email:)
    schedule_item = find_instance(@@instances, schedule_item_id)
    if schedule_item.nil? || schedule_item.speaker_email != email
      ExternalEventApi::FindScheduleItemService.call(email: email, schedule_item_id: schedule_item_id)
    else
      schedule_item
    end
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
