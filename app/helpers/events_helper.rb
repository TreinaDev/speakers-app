module EventsHelper
  def ongoing(event)
    event.start_date <= Date.current && event.end_date >= Date.current
  end

  def future_events(event)
    event.start_date > Date.current
  end

  def past_events(event)
    event.end_date < Date.current
  end
end
