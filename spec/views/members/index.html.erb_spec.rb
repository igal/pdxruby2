require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/index.html.erb" do
  include MembersHelper

  before(:each) do
    assigns[:members] = [
      stub_model(Member,
        :name => "value for name",
        :email => "value for email",
        :password => "value for password",
        :feed_url => "value for feed_url",
        :about => "value for about"
      ),
      stub_model(Member,
        :name => "value for name",
        :email => "value for email",
        :password => "value for password",
        :feed_url => "value for feed_url",
        :about => "value for about"
      )
    ]
  end

  it "renders a list of members" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", "value for password".to_s, 2)
    response.should have_tag("tr>td", "value for feed_url".to_s, 2)
    response.should have_tag("tr>td", "value for about".to_s, 2)
  end
end
