require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/index.html.erb" do
  include LocationsHelper

  fixtures :members, :locations, :events

  before(:each) do
    @cubespace = locations(:cubespace)
    assigns[:locations] = [ @cubespace ]
  end

  it "renders a list of locations" do
    render
    response.should have_text /#{@cubespace.name}/
    response.should have_text /#{@cubespace.address}/
  end
end
