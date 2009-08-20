require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/index.html.erb" do
  include LocationsHelper

  before(:each) do
    assigns[:locations] = [
      stub_model(Location,
        :name => "value for name",
        :address => "value for address",
        :homepage => "value for homepage"
      ),
      stub_model(Location,
        :name => "value for name",
        :address => "value for address",
        :homepage => "value for homepage"
      )
    ]
  end

  it "renders a list of locations" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for address".to_s, 2)
    response.should have_tag("tr>td", "value for homepage".to_s, 2)
  end
end
