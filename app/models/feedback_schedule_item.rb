class FeedbackScheduleItem
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :title, :string
  attribute :comment, :string
  attribute :mark, :integer
  attribute :user, :string
  attribute :schedule_item_id, :string


  def initialize(**params)
    super(feedback_schedule_item_permited_params(params))
  end

  def self.schedule(schedule_item_code:)
    ExternalParticipantApi::GetScheduleItemFeedbacksService.call(schedule_item_id: schedule_item_code)
  end

  private

  def feedback_schedule_item_permited_params(params)
    ActionController::Parameters.new(params).permit(FeedbackScheduleItem.attribute_names)
  end
end
