class Feedback
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :title, :string
  attribute :comment, :string
  attribute :mark, :integer
  attribute :user, :string

  def initialize(**params)
    super(feedback_permited_params(params))
  end

  def self.event(event_code:, speaker:)
    ExternalParticipantApi::GetEventFeedbacksService.call(event_code: event_code, speaker: speaker)
  end

  private

  def feedback_permited_params(params)
    ActionController::Parameters.new(params).permit(Feedback.attribute_names)
  end
end
