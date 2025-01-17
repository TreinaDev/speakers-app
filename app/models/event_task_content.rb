class EventTaskContent < ApplicationRecord
  belongs_to :event_contents
  belongs_to :event_tasks
end
