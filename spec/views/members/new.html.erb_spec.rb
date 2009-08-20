require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/new.html.erb" do
  include MembersHelper

  before(:each) do
    assigns[:member] = stub_model(Member,
      :new_record? => true,
      :name => "value for name",
      :email => "value for email",
      :password => "value for password",
      :feed_url => "value for feed_url",
      :about => "value for about"
    )
  end

  it "renders new member form" do
    render

    response.should have_tag("form[action=?][method=post]", members_path) do
      with_tag("input#member_name[name=?]", "member[name]")
      with_tag("input#member_email[name=?]", "member[email]")
      with_tag("input#member_password[name=?]", "member[password]")
      with_tag("input#member_feed_url[name=?]", "member[feed_url]")
      with_tag("textarea#member_about[name=?]", "member[about]")
    end
  end
end
