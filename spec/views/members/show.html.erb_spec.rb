require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/show.html.erb" do
  include MembersHelper

  fixtures :members

  before(:each) do
    assigns[:member] = @member = members(:aaron)
  end

  def response_should_have_common_attributes
    response.should have_text /#{@member.name}/
    response.should have_text /#{@member.about}/
  end

  def response_should_have_email_attributes
    response.should have_text /Email/
    response.should have_text /decodeURIComponent/
  end

  def response_should_not_have_email_attributes
    response.should_not have_text /Email/
    response.should_not have_text /decodeURIComponent/
  end

  def response_should_have_spammer_attribute
    response.should have_text /Spammer/
  end

  def response_should_not_have_spammer_attribute
    response.should_not have_text /Spammer/
  end

  it "renders attributes of non-spammer for anonymous user" do
    logout
    render
    
    response_should_have_common_attributes
    response_should_not_have_email_attributes
    response_should_not_have_spammer_attribute
  end

  it "renders attributes of non-spammer for logged-in user" do
    login_as :bubba
    render

    response_should_have_common_attributes
    response_should_have_email_attributes
    response_should_not_have_spammer_attribute
  end

  it "renders attributes of spammer for anonymous user" do
    assigns[:member] = @member = members(:spammy)
    logout
    render

    response_should_have_common_attributes
    response_should_not_have_email_attributes
    response_should_have_spammer_attribute
  end
end
