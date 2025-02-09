class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedule_item = ScheduleItem.find(schedule_item_code: params[:code], token: current_user&.token)
    return redirect_to events_path, alert: t('.not_found') if @schedule_item.nil?
    @event = Event.find(code: @schedule_item.event_code, token: current_user.token)
    add_breadcrumb @event.name, event_path(@schedule_item.event_code) if @event
    add_breadcrumb @schedule_item.name, "#" if @schedule_item
    @participants = @schedule_item.participants
    generate_curriculum if @schedule_item
    @schedule_item_feedbacks = FeedbackScheduleItem.schedule(schedule_item_code: @schedule_item.code)
  end

  private

  def generate_curriculum
    @curriculum = Curriculum.find_or_create_by(user_id: current_user.id, schedule_item_code: @schedule_item.code)
  end
end
