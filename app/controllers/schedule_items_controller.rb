class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedule_item = ScheduleItem.find(schedule_item_id: params[:id], email: current_user.email)
    redirect_to events_path, alert: t('.not_found') if @schedule_item.nil?
    @participants = @schedule_item&.participants
    generate_curriculum if @schedule_item
  end

  private

  def generate_curriculum
    @curriculum = Curriculum.find_or_create_by(user_id: current_user.id, schedule_item_code: @schedule_item.id)
  end
end
