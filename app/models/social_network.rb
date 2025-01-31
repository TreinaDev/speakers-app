class SocialNetwork < ApplicationRecord
  belongs_to :profile
  validates :url, :social_network_type, presence: true
  enum :social_network_type, { my_site: 0, youtube: 1, x: 2, github: 3, facebook: 4 }
  validate :validate_url_type

  def translated_social_network_type(type)
    I18n.t("activerecord.attributes.social_network.social_network_type.#{type}")
  end

  private

  def validate_url_type
    valid_url = [ 'www.facebook.com', 'www.youtube.com', 'x.com', 'github.com' ]
    if social_network_type == 'my_site'
      errors.add(:url, I18n.t('activerecord.errors.messages.invalid_for') + translated_social_network_type(social_network_type)) unless valid_my_site_domain?
    else
      errors.add(:url, I18n.t('activerecord.errors.messages.invalid_for') +
                translated_social_network_type((social_network_type))
                ) if !valid_url.any? { |validation| url.present? && url.include?(validation) } && social_network_type.present?
    end
  end

  def valid_my_site_domain?
    /^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(\/[\w\-\.~!*'\(\);:@&=+$,#\[\]]*)?$/.match?(url)
  end
end
