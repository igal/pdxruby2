require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/new.html.erb" do
  include MembersHelper

  fixtures :members

  before(:each) do
    assigns[:member] = @member = Member.new
  end

  it "renders new member form" do
    render

    response.should have_tag("form[action=?][method=post]", members_path) do
      with_tag("input#member_name[name=?]", "member[name]")
      with_tag("input#member_email[name=?]", "member[email]")
      with_tag("textarea#member_about[name=?]", "member[about]")
    end
  end
end
