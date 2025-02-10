class ScheduleItem
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :description, :string
  attribute :date, :date
  attribute :start_time, :time
  attribute :end_time, :time
  attribute :responsible_name, :string
  attribute :responsible_email, :string
  attribute :schedule_type, :string
  attribute :code, :string
  attribute :event_code, :string
  attribute :event_start_date, :datetime
  attribute :event_end_date, :datetime

  @@instances = []
  def initialize(**params)
    super(schedule_item_permitted_params(params))
    @@instances << self
  end

  def self.find(schedule_item_code:, token:)
    ExternalEventApi::FindScheduleItemService.call(token: token, schedule_item_code: schedule_item_code)
  end

  def self.count
    @@instances.size
  end

  def self.delete_all
    @@instances = []
  end

  private

  def schedule_item_permitted_params(params)
    ActionController::Parameters.new(params).permit(ScheduleItem.attribute_names)
  end
end
