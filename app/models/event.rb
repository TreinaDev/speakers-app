class Event
  extend ActiveModel::Translation

  attr_accessor :id, :name, :url, :description, :start_date, :end_date, :event_type, :location, :participant_limit, :status

  @@instances = []
  def initialize(id:, name:, url:, description:, start_date:, end_date:, event_type:, location:, participant_limit:, status:)
    @id = id
    @name = name
    @url = url
    @description = description
    @start_date = start_date
    @end_date = end_date
    @event_type = event_type
    @location = location
    @participant_limit = participant_limit
    @status = status
    @@instances << self
  end


  def self.all(email)
    ExternalEventApi::GetAllEventsService.call(email: email)
  end

  def self.find(id)
    ExternalEventApi::FindEventService.call(id: id)
  end

  def schedule_items(email)
    ExternalEventApi::ScheduleItemsService.call(event_id: id, email: email)
  end

  def self.count
    @@instances.size
  end

  def self.last
    @@instances.last
  end

  def self.delete_all
    @@instances = []
  end

  def participants
    ExternalParticipantApi::EventListParticipantsService.new(event_id: id).call
  end
end
