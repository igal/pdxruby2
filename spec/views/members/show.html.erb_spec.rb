require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/show.html.erb" do
  include MembersHelper
  
  fixtures :members

  before(:each) do
    assigns[:member] = @member = members(:aaron)
  end

  it "renders attributes in <p>" do
    render
    response.should have_text /#{@member.name}/
    response.should have_text /#{@member.about}/
  end
end
