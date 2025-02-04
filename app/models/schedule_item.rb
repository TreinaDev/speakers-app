class ScheduleItem
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :description, :string
  attribute :start_time, :time
  attribute :end_time, :time
  attribute :responsible_name, :string
  attribute :responsible_email, :string
  attribute :schedule_type, :string
  attribute :code, :string

  @@instances = []
  def initialize(**params)
    super(schedule_item_parmited_params(params))
    @@instances << self
  end

  def self.find(schedule_item_code:, email:)
    ExternalEventApi::FindScheduleItemService.call(email: email, schedule_item_code: schedule_item_code)
  end

  def self.count
    @@instances.size
  end

  def self.delete_all
    @@instances = []
  end

  def participants
    ExternalParticipantApi::ListParticipantsService.call(schedule_item_code: code)
  end

  private

  def schedule_item_parmited_params(params)
    ActionController::Parameters.new(params).permit(ScheduleItem.attribute_names)
  end
end
