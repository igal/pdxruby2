class HomeController < ApplicationController
  def index
    @events = Event.recent
  end
end
