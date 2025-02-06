class UpdateHistory < ApplicationRecord
  belongs_to :event_content
  belongs_to :user

  validates :description, :creation_date, presence: true
end
