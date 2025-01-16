class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def redirect_if_authenticated
    redirect_to events_path if user_signed_in?
  end
end
