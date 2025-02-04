class Schedule
  extend ActiveModel::Translation

  attr_accessor :date

  @association = []
  def initialize(date:)
    @date = date
  end
end
