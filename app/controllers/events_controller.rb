class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.all(current_user.token).sort_by { |event| event.start_date }.reverse
    @paginated_events = Kaminari.paginate_array(@events).page(params[:page]).per(15)
  end

  def show
    @event = Event.find(code: params[:code], token: current_user.token)
    return redirect_to events_path, alert: t('event.show.event_not_find') unless @event
    add_breadcrumb @event.name, "#" if @event
    @schedules = @event&.schedule_items(current_user.token)&.group_by { |schedule| schedule[:schedule].itself }
    @feedbacks = Feedback.event(event_code: @event&.code, speaker: current_user.email)
    @participants = @event&.participants
  end
end
