require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/new.html.erb" do
  include EventsHelper

  fixtures :members, :locations, :events

  before(:each) do
    assigns[:event] = @event = events(:meeting)
    assigns[:locations] = @locations = Location.all
  end

  it "renders new event form" do
    render

    assert_select('input#event_name')
    assert_select('textarea#event_agenda')
    assert_select('textarea#event_minutes')
  end
end
