require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/edit.html.erb" do
  include MembersHelper

  fixtures :members

  before(:each) do
    assigns[:member] = @member = members(:aaron)
  end

  it "renders the edit member form" do
    render

    response.should have_tag("form[action=#{member_path(@member)}][method=post]") do
      have_text /#{@member.name}/
      have_text /#{@member.about}/
      with_tag('input#member_name[name=?]', "member[name]")
      with_tag('input#member_email[name=?]', "member[email]")
      with_tag('textarea#member_about[name=?]', "member[about]")
    end
  end
end
