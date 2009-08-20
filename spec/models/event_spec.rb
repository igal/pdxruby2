require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @valid_attributes = {
      :member_id => 1,
      :location_id => 1,
      :name => "value for name",
      :starts_at => Time.now,
      :ends_at => Time.now,
      :agenda => "value for agenda",
      :created_at => Time.now,
      :minutes => "value for minutes",
      :status => "value for status"
    }
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
end
