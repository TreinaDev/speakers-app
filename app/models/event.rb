class Event < ApplicationModel
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
    Event.delete_all
    ExternalEventApi::GetAllEventsService.call(email: email)
  end

  def self.find(id)
    event = find_instance(@@instances, id)
    if event.nil?
      ExternalEventApi::FindEventService.call(id: id)
    else
      event
    end
  end

  def schedule_items(email)
    ScheduleItem.delete_all
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
end
