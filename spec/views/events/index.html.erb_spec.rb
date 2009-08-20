require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/index.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:events] = [
      stub_model(Event,
        :member_id => 1,
        :location_id => 1,
        :name => "value for name",
        :agenda => "value for agenda",
        :minutes => "value for minutes",
        :status => "value for status"
      ),
      stub_model(Event,
        :member_id => 1,
        :location_id => 1,
        :name => "value for name",
        :agenda => "value for agenda",
        :minutes => "value for minutes",
        :status => "value for status"
      )
    ]
  end

  it "renders a list of events" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for agenda".to_s, 2)
    response.should have_tag("tr>td", "value for minutes".to_s, 2)
    response.should have_tag("tr>td", "value for status".to_s, 2)
  end
end
