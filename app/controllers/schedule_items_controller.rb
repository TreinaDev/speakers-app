class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_show

  def show; end

  def answer
    answer = FeedbackScheduleItem.post_answer(feedback_id: params[:feedback_id], name: current_user.full_name, email: current_user.email, answer: params[:comment])
    answer ? flash[:notice] = t('.success') : flash[:alert] = t('.failure')

    render :show, status: :unprocessable_entity
  end

  private

  def generate_curriculum
    @curriculum = Curriculum.find_or_create_by(user_id: current_user.id, schedule_item_code: @schedule_item.code)
  end

  def setup_show
    @schedule_item = ScheduleItem.find(schedule_item_code: params[:code], token: current_user&.token)
    return redirect_to events_path, alert: t('.not_found') if @schedule_item.nil?
    @event = Event.find(code: @schedule_item.event_code, token: current_user.token)
    add_breadcrumb @event.name, event_path(@schedule_item.event_code) if @event
    add_breadcrumb @schedule_item.name, "#"
    generate_curriculum
    @schedule_item_feedbacks = FeedbackScheduleItem.schedule(schedule_item_code: @schedule_item.code)
    @participant_records = ParticipantRecord.where(schedule_item_code: @schedule_item.code)

    @participants = @participant_records.map { |record| Participant.find(participant_code: record.participant_code) } if @participant_records
  end
end
