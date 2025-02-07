class EventsController < ApplicationController
  include EventsHelper
  before_action :authenticate_user!
  def index
    @events = Event.all(current_user.token).sort_by { |event| event.start_date }.reverse
    @ongoing_events = @events.select { |event| ongoing(event) }
    @future_events = @events.select { |event| future_events(event) }
    @past_events = @events.select { |event| past_events(event) }

    @paginated_ongoing_events = Kaminari.paginate_array(@ongoing_events).page(params[:ongoing_page]).per(9)
    @paginated_future_events = Kaminari.paginate_array(@future_events).page(params[:future_page]).per(9)
    @paginated_past_events = Kaminari.paginate_array(@past_events).page(params[:past_page]).per(9)
  end

  def show
    @event = Event.find(code: params[:code], token: current_user.token)
    redirect_to events_path, alert: t('event.show.event_not_find') unless @event
    @schedules = @event&.schedule_items(current_user.token)&.group_by { |schedule| schedule[:schedule].itself }
    @feedbacks = Feedback.event(event_code: @event&.code, speaker: current_user.email)
    @participants = @event&.participants
  end
end
