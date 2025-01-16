class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.all.presence || mock_events
  end

  def mock_events
    [
      Event.new(id: 1, name: "Event1", url: "", description: "Event1 description", start_date: "14-01-2025", end_date: "16-01-2025",
                event_type: "in-person", location: "Palhoça", participant_limit: 20, status: "published"),
      Event.new(id: 2, name: "Event2",  url: "", description: "Event2 description", start_date: "15-01-2025", end_date: "17-01-2025",
                  event_type: "in-person", location: "Florianópolis", participant_limit: 20, status: "draft")
    ]
  end
end
