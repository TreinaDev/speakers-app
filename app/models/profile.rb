class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture
  has_many :social_networks
  validates :title, :about_me, :profile_picture, :city, :gender, :pronoun, :birth, presence: true
  validates :username, uniqueness: true
  before_create :generate_unique_username
  validate :validation_for_birth

  def self.pronoun_options
    [ I18n.t('profiles.pronoun_options.she_her'), I18n.t('profiles.pronoun_options.he_him'),
      I18n.t('profiles.pronoun_options.they_them'), I18n.t('profiles.pronoun_options.prefer_not_inform'),
      I18n.t('profiles.pronoun_options.other') ]
  end

  def self.gender_options
    [ I18n.t('profiles.gender_options.male'), I18n.t('profiles.gender_options.female'),
      I18n.t('profiles.gender_options.not_binary'), I18n.t('profiles.gender_options.prefer_not_answer'),
      I18n.t('profiles.gender_options.other') ]
  end

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

  def validation_for_birth
    errors.add(:base, I18n.t("activerecord.errors.messages.validation_for_birth")) if self.birth.present? && self.birth >= 18.years.ago
  end
end
