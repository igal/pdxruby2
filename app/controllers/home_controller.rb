class HomeController < ApplicationController
  def index
    @events = Defer { ::Event.recent }
  end

  # Raise exception, mostly for confirming that exception_notification works.
  def omfg
    raise ArgumentError, "OMFG"
  end
end
