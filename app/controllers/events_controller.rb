class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.all(current_user.token)
  end

  def show
    @event = Event.find(params[:code])
    redirect_to events_path, alert: t('event.show.event_not_find') unless @event
    @schedule_items = @event&.schedule_items(current_user.email)
    @feedbacks = Feedback.event(event_code: @event&.code, speaker: current_user.email)
    @participants = @event&.participants
  end
end
