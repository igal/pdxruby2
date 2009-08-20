# == Schema Information
# Schema version: 20090819180345
#
# Table name: locations
#
#  id         :integer         not null, primary key
#  name       :string(128)
#  homepage   :string(256)
#  address    :string(1024)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :address => "value for address",
      :homepage => "value for homepage",
      :created_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes)
  end
end
