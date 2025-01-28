class ScheduleItem
  extend ActiveModel::Translation

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

  def self.find(id, email)
    ExternalEventApi::FindScheduleItemService.call(id, email)
  end

  def self.count
    @@instances.size
  end

  def self.delete_all
    @@instances = []
  end

  def participants
    ExternalParticipantApi::ListParticipantsService.call(id)
  end
end
