class UpdateHistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_content = current_user.event_contents.find_by(code: params[:event_content_code])
    unless @event_content
      flash[:alert] = t('update_histories.index.content_unavailable')
      return redirect_to events_path
    end
    @update_histories = @event_content.update_histories.sort_by(&:creation_date).reverse
  end
end
