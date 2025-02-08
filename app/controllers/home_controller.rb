class HomeController < ApplicationController
  before_action :redirect_if_authenticated
  skip_before_action :set_breadcrumb
  def index
  end
end
