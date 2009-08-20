require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/show.html.erb" do
  include MembersHelper
  before(:each) do
    assigns[:member] = @member = stub_model(Member,
      :name => "value for name",
      :email => "value for email",
      :password => "value for password",
      :feed_url => "value for feed_url",
      :about => "value for about"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ email/)
    response.should have_text(/value\ for\ password/)
    response.should have_text(/value\ for\ feed_url/)
    response.should have_text(/value\ for\ about/)
  end
end
