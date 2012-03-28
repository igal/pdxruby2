class HomeController < ApplicationController
  before_filter :reject_spammer, :only => [:spammers_forbidden]

  def index
    @events = Defer { ::Event.future }
  end

  def job_guidelines
    
  end

  # Raise exception, mostly for confirming that exception_notification works.
  def omfg
    raise ArgumentError, "OMFG"
  end

  # Method for testing the #reject_spammer filter.
  def spammers_forbidden
    render :text => "Welcome, non-spammer!"
  end
end
