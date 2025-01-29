class Feedback
  attr_accessor :id, :name, :title, :description

  def initialize(id:, name:, title:, description:)
    @id = id
    @name = name
    @title = title
    @description = description
  end

  def self.event(event_id:, speaker:)

  end
end