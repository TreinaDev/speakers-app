class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.all(current_user.email)
  end

  def show
    @event = Event.find(params[:id])
    @schedule_items = @event&.schedule_items(current_user.email)
    redirect_to events_path, alert: 'Evento não localizado!' unless @event
  end
end
