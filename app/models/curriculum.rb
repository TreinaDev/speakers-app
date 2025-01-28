class Curriculum < ApplicationRecord
  belongs_to :user
  has_many :curriculum_contents
  has_many :event_contents, through: :curriculum_contents
end
