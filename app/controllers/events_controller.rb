class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.all(current_user.token)
  end

  def show
    @event = Event.find(params[:code])
    return redirect_to events_path, alert: 'Página indisponível' unless @event

    @schedule_items = @event&.schedule_items(current_user.email)
    @feedbacks = Feedback.event(event_code: @event&.code, speaker: current_user.email)
    @participants = @event&.participants
  end
end
