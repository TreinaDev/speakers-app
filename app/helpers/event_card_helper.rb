module EventCardHelper
  def event_card(event)
    content_tag :li, id: event.code, class: "event__card border border-gray-200 w-96 p-5 rounded-lg shadow flex-column items-center" do
      event_image(event) +
      event_title(event) +
      event_footer(event)
    end
  end

  private

  def event_image(event)
    image_tag(event.logo_url.presence || "default_image.jpeg",
              class: "h-56 w-full object-cover rounded-lg",
              alt: t('views.events.events.no_image'))
  end

  def event_title(event)
    content_tag :h2, event.name, class: "text-2xl font-bold text-indigo-700 w-96 mb-2 mt-2 truncate w-full"
  end

  def event_footer(event)
    content_tag :div, class: "event__card-footer" do
      event_date(event) + event_address(event)
    end
  end

  def event_date(event)
    content_tag :div, class: "event__card-date" do
      content_tag(:p, day(event.start_date), class: "event__card-date-day") +
      content_tag(:p, month_name(event.start_date), class: "event__card-date-month") +
      content_tag(:p, year(event.start_date), class: "event__card-date-year")
    end
  end

  def event_address(event)
    content_tag :div, class: "event__card-address" do
      image_tag('location.svg', class: 'icon') +
      content_tag(:p, event.address, class: "event__card-address-name")
    end
  end
end
