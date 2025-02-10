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

  @@instances = []
  def initialize(**params)
    super(feedback_schedule_item_permited_params(params))
    @@instances << self
  end

  def self.schedule(schedule_item_code:)
    ExternalParticipantApi::GetScheduleItemFeedbacksService.call(schedule_item_id: schedule_item_code)
  end

  def self.post_answer(feedback_id:, name:, email:, answer:)
    ExternalParticipantApi::PostAnswerService.call(feedback_id: feedback_id, name: name, email: email, answer: answer)
  end

  def self.count
    @@instances.size
  end

  def self.delete_all
    @@instances = []
  end

  private

  def feedback_schedule_item_permited_params(params)
    ActionController::Parameters.new(params).permit(FeedbackScheduleItem.attribute_names)
  end
end
