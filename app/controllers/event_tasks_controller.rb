class EventTasksController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def new
    @event_task = EventTask.new
  end

  def create; end
end
