class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_if_user_has_profile, unless: :devise_controller?
  before_action :set_breadcrumb, unless: :devise_controller?

  protected

  def redirect_if_authenticated
    redirect_to events_path if user_signed_in?
  end

  def check_if_user_has_profile
    if user_signed_in? && current_user.profile.blank?
      flash[:info] = 'É necessário registrar seu perfil antes de prosseguir.'
      redirect_to new_profile_path
    end
  end

  def set_breadcrumb
    add_breadcrumb t("home_title"), events_path
  end
end
