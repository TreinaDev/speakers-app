class EventTask < ApplicationRecord
  enum :certificate_requirement, { mandatory: 1, optional: 0 }
end

