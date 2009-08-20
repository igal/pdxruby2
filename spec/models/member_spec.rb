require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "value for email",
      :password => "value for password",
      :feed_url => "value for feed_url",
      :about => "value for about",
      :created_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end
end
