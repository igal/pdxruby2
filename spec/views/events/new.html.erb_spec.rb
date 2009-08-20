require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/new.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:event] = stub_model(Event,
      :new_record? => true,
      :member_id => 1,
      :location_id => 1,
      :name => "value for name",
      :agenda => "value for agenda",
      :minutes => "value for minutes",
      :status => "value for status"
    )
  end

  it "renders new event form" do
    render

    response.should have_tag("form[action=?][method=post]", events_path) do
      with_tag("input#event_member_id[name=?]", "event[member_id]")
      with_tag("input#event_location_id[name=?]", "event[location_id]")
      with_tag("input#event_name[name=?]", "event[name]")
      with_tag("textarea#event_agenda[name=?]", "event[agenda]")
      with_tag("textarea#event_minutes[name=?]", "event[minutes]")
      with_tag("input#event_status[name=?]", "event[status]")
    end
  end
end
