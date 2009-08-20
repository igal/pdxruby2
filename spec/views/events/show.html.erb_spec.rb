require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/show.html.erb" do
  include EventsHelper
  before(:each) do
    assigns[:event] = @event = stub_model(Event,
      :member_id => 1,
      :location_id => 1,
      :name => "value for name",
      :agenda => "value for agenda",
      :minutes => "value for minutes",
      :status => "value for status"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ agenda/)
    response.should have_text(/value\ for\ minutes/)
    response.should have_text(/value\ for\ status/)
  end
end
