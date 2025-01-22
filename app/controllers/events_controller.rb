class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    email = current_user.email

    @schedule_items = @event&.schedule_items(email)
    redirect_to events_path, alert: 'Evento não localizado!' unless @event
  end
end
