class Event
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :event_type, :string
  attribute :description, :string
  attribute :address, :string
  attribute :participants_limit, :integer
  attribute :url, :string
  attribute :status, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :code, :string
  attribute :start_date, :datetime
  attribute :end_date, :datetime
  attribute :logo_url, :string
  attribute :banner_url, :string
  attribute :event_owner, :string

  @@instances = []
  def initialize(**params)
    super(event_permitted_params(params))
    @@instances << self
  end


  def self.all(token)
    ExternalEventApi::GetAllEventsService.call(token: token)
  end

  def self.find(code)
    ExternalEventApi::FindEventService.call(code: code)
  end

  def schedule_items(token)
    ExternalEventApi::ScheduleItemsService.call(event_code: code, token: token)
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
    ExternalParticipantApi::EventListParticipantsService.new(event_code: code).call
  end

  private

  def event_permitted_params(params)
    ActionController::Parameters.new(params).permit(Event.attribute_names)
  end
end
