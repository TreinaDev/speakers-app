class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedule_item = ScheduleItem.find(params[:id], current_user.email)
    redirect_to events_path, alert: t('.not_found') unless @schedule_item
  end
end
