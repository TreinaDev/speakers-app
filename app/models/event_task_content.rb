class EventTaskContent < ApplicationRecord
  belongs_to :event_content
  belongs_to :event_task
end
