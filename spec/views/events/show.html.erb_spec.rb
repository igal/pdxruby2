require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/show.html.erb" do
  include EventsHelper

  fixtures :members, :locations, :events

  before(:each) do
    assigns[:event] = @event = events(:meeting)
  end

  it "renders attributes in <p>" do
    render
    response.should have_text /#{@event.name}/
    response.should have_text /#{@event.agenda}/
    response.should have_text /#{@event.location.name}/
  end
end
