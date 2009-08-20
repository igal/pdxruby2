require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/index.html.erb" do
  include EventsHelper
  fixtures :members, :locations, :events

  before(:each) do
    assigns[:events] = [ events(:meeting), events(:meeting2) ].paginate
  end

  it "renders a list of events" do
    render
    response.should have_tag("tr>td", events(:meeting).name, 1)
    response.should have_tag("tr>td", events(:meeting2).name, 1)
    response.should have_tag("tr>td", events(:meeting).location.name, 1)
    response.should have_tag("tr>td", events(:meeting2).location.name, 1)
  end
end
