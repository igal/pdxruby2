require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/edit.html.erb" do
  include EventsHelper

  fixtures :members, :locations, :events

  before(:each) do
    assigns[:event] = @event = events(:meeting)
    assigns[:locations] = @locations = Location.all
  end

  it "renders the edit event form" do
    render
    assert_select('input#event_name[value=?]', @event.name)
    assert_select('textarea#event_agenda', @event.agenda)
    assert_select('textarea#event_minutes', @event.minutes)
  end
end
