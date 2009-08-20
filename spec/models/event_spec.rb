# == Schema Information
# Schema version: 20090819180345
#
# Table name: events
#
#  id          :integer         not null, primary key
#  location_id :integer
#  member_id   :integer
#  starts_at   :datetime
#  ends_at     :datetime
#  name        :string(128)
#  status      :string(64)
#  agenda      :string(16384)
#  minutes     :string(16384)
#  created_at  :datetime
#  updated_at  :datetime
#  cancelled   :boolean
#

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
