module ApplicationHelper
  def event_card(event, img, width = "w-96")
    content_tag :li, id: event.code, class: "border border-gray-200 w-96 p-6 rounded-lg shadow flex-column items-center" do
      image_tag(img, class: "#{ width } h-48 w-full object-cover rounded-lg mr-6") +
      content_tag(:h2, event.name, class: "text-2xl font-bold text-indigo-700 hover:text-indigo-900 mb-2") +
      content_tag(:p) do
        "#{Event.human_attribute_name(:start_date)} #{formatted_date(event.start_date)}".html_safe
      end +
      content_tag(:b, Event.human_attribute_name(event.status))
    end
  end

  def unpublished(event)
    event_card(event, "unpublished.svg", "w-48")
  end

  def published(event)
    event_card(event, "default_image.jpeg")
  end
end
