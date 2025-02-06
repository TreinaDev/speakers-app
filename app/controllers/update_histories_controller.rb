class UpdateHistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_content = current_user.event_contents.find_by(code: params[:event_content_code])
    unless @event_content
      flash[:alert] = t('update_histories.index.content_unavailable')
      redirect_to events_path
    end
  end
end
