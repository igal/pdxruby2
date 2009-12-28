require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/show.html.erb" do
  include MembersHelper

  fixtures :members

  before(:each) do
    assigns[:member] = @member = members(:aaron)
  end

  it "renders attributes for anonymous user" do
    logout

    render
    response.should have_text /#{@member.name}/
    response.should have_text /#{@member.about}/

    response.should_not have_text /Email/
    response.should_not have_text /decodeURIComponent/
  end

  it "renders attributes for logged-in user" do
    login_as :bubba

    render
    response.should have_text /#{@member.name}/
    response.should have_text /#{@member.about}/

    response.should have_text /Email/
    response.should have_text /decodeURIComponent/
  end
end
