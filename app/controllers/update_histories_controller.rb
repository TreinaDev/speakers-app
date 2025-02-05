class UpdateHistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @event_content = current_user.event_contents.find_by(event_content_code: params[:event_content_code])
  end
end
