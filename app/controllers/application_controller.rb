class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # before_action :redirect_if_dont_have_profile

  protected

  def redirect_if_authenticated
    redirect_to events_path if user_signed_in?
  end

  def redirect_if_dont_have_profile
    redirect_to new_profile_path if user_signed_in? && current_user.profile.nil?
  end
end
