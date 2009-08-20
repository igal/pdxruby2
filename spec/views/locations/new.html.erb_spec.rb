require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/new.html.erb" do
  include LocationsHelper

  before(:each) do
    assigns[:location] = stub_model(Location,
      :new_record? => true,
      :name => "value for name",
      :address => "value for address",
      :homepage => "value for homepage"
    )
  end

  it "renders new location form" do
    render

    response.should have_tag("form[action=?][method=post]", locations_path) do
      with_tag("input#location_name[name=?]", "location[name]")
      with_tag("textarea#location_address[name=?]", "location[address]")
      with_tag("input#location_homepage[name=?]", "location[homepage]")
    end
  end
end
