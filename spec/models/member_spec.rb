# == Schema Information
# Schema version: 20090819180345
#
# Table name: members
#
#  id                :integer         not null, primary key
#  name              :string(128)
#  email             :string(512)
#  password          :string(256)
#  feed_url          :string(512)
#  irc_nick          :string(128)
#  persistence_token :string(1024)
#  about             :string(16384)
#  created_at        :datetime
#  updated_at        :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "email@host.com",
      :password => "value for password",
      :feed_url => "value for feed_url",
      :about => "value for about",
      :created_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end

  describe "authentication" do
    before(:each) do
      @plain_password = "foo"
      @hashed_password = Digest::SHA1.hexdigest(@plain_password)
    end

    it "should provide a way to hash passwords" do
      Member.hashed_password(@plain_password).should == @hashed_password
    end

    it "should hash password on assignment" do
      member = Member.new
      member.password = @plain_password

      member.password.should == @hashed_password
    end

    it "should validate password matches" do
      member = Member.new
      member.password = @plain_password

      member.valid_password?(@plain_password).should be_true
    end
  end
end
