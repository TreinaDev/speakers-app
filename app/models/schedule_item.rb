class ScheduleItem
  attr_accessor :id, :title, :speaker_email, :description, :lenght

  def initialize(id:, title:, speaker_email:, description:, lenght:)
    @id = id
    @title = title
    @speaker_email = speaker_email
    @description = description
    @lenght = lenght
  end
end
