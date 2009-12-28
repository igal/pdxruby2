require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/index.html.erb" do
  include MembersHelper

  fixtures :members

  before(:each) do
    assigns[:members] = @members = [ members(:aaron), members(:bubba), members(:clio) ]
  end

  it "renders a list of members for anonymous user" do
    logout

    render
    response.should have_text /#{@members[0].name}/
    response.should have_text /#{@members[1].name}/
    response.should have_text /#{@members[2].name}/

    response.should have_text /#{member_path(@members[0])}/

    response.should_not have_text /Email/
    response.should_not have_text /decodeURIComponent/
  end

  it "renders a list of members with emails for logged-in user" do
    login_as :bubba

    render
    response.should have_text /#{@members[0].name}/
    response.should have_text /#{@members[1].name}/
    response.should have_text /#{@members[2].name}/

    response.should have_text /#{member_path(@members[0])}/

    response.should have_text /Email/
    response.should have_text /decodeURIComponent/
  end
end
