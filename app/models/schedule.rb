class Schedule
  extend ActiveModel::Translation

  attr_accessor :date

  @association = []
  def initialize(date:)
    @date = date
  end

  def build_schedule_item(**params)
    @@association << ScheduleItem.new(**params)
  end
end
