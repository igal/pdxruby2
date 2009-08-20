require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/show.html.erb" do
  include LocationsHelper
  before(:each) do
    assigns[:location] = @location = stub_model(Location,
      :name => "value for name",
      :address => "value for address",
      :homepage => "value for homepage"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ address/)
    response.should have_text(/value\ for\ homepage/)
  end
end
