class ScheduleItem
  extend ActiveModel::Translation

  attr_accessor :id, :title, :speaker_email, :description, :lenght
  @@instances = []
  def initialize(id:, title:, speaker_email:, description:, lenght:)
    @id = id
    @title = title
    @speaker_email = speaker_email
    @description = description
    @lenght = lenght
    @@instances << self
  end

  def self.count
    @@instances.size
  end

  def self.delete_all
    @@instances = []
  end
end
