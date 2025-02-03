class Feedback
  extend ActiveModel::Translation

  attr_accessor :id, :name, :title, :description

  def initialize(id:, name:, title:, description:)
    @id = id
    @name = name
    @title = title
    @description = description
  end

  def self.event(event_code:, speaker:)
    ExternalParticipantApi::GetEventFeedbacksService.call(event_code: event_code, speaker: speaker)
  end
end
