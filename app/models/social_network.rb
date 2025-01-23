class SocialNetwork < ApplicationRecord
  belongs_to :profile
  validates :url, :social_network_type, presence: true
  enum :social_network_type, { my_site: 0, youtube: 1, twitter: 2, github: 3, facebook: 4 }
  validate :validate_url_type

  private

  def validate_url_type
    valid_url = [ 'www.facebook.com', 'www.youtube.com', 'x.com', 'github.com' ]
    if social_network_type == 'my_site'
      errors.add(:url, 'inválida para ' + translated_social_network_type) unless valid_my_site_domain?
    else
      errors.add(:url, 'inválida para ' +
                translated_social_network_type) if !valid_url.any? { |validation| url.present? && url.include?(validation) } && social_network_type.present?
    end
  end

  def translated_social_network_type
    I18n.t("activerecord.attributes.social_network.social_network_type.#{social_network_type}")
  end

  def valid_my_site_domain?
    /^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(\/[\w\-\.~!*'\(\);:@&=+$,#\[\]]*)?$/.match?(url)
  end
end
