class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture
  has_many :social_networks
  validates :title, :about_me, :profile_picture, presence: true
end
