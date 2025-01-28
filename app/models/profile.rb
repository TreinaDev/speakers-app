class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture
  has_many :social_networks
  validates :title, :about_me, :profile_picture, presence: true
  validates :username, uniqueness: true
  before_create :generate_unique_username

  private

  def generate_unique_username
    return if user.nil?

    base_username = user.full_name.gsub(' ', '_').parameterize
    username_candidate = base_username
    count = 1

    while Profile.exists?(username: username_candidate)
      username_candidate = "#{base_username}#{count}"
      count += 1
    end

    self.username = username_candidate
  end
end
