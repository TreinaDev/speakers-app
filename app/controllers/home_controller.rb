class HomeController < ApplicationController
  before_action :redirect_if_authenticated
  def index
    
  end
end
