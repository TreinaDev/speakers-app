class ExternalParticipantApi::GetScheduleItemFeedbacksService < ApplicationService
  def call
    get_schedule_item_feedbacks
  end

  private

  def get_schedule_item_feedbacks
    schedule_item_feedbacks = []
    begin
      response = ParticipantClient.schedule_item_feedbacks(schedule_item_id: kwargs[:schedule_item_id])
      if response.success?
        json_response = JSON.parse(response.body)

        json_response['item_feedbacks'].each do |schedule_item_feedback|
          schedule_item_feedbacks << FeedbackScheduleItem.new(**schedule_item_feedback)
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
    end
    schedule_item_feedbacks
  end
end
