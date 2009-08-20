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

  describe "ended?" do
    it "should mark a future as event as not yet ended" do
      event = Event.new(:ends_at => 1.minute.from_now)
      event.ended?.should be_false
    end

    it "should mark a past event as ended" do
      event = Event.new(:ends_at => 1.minute.ago)
      event.ended?.should be_true
    end
  end

  describe "to_icalendar" do
    def assert_calendar_match(item, component, url_helper=nil)
      component.should_not be_nil
      component.dtstart.utc.to_i.should == item.starts_at.utc.to_i
      component.dtend.utc.to_i.should == item.ends_at.utc.to_i
      component.summary.should == item.name
      component.description.should == item.agenda
      component.url.should == url_helper.call(item) if url_helper
    end

    # Return the calendar component matching the given item's name.
    def find_calendar_match(item, components)
      return components.find{|component| component.summary == item.name}
    end
    
    def find_and_assert_calendar_match(item, components, url_helper=nil)
      assert_calendar_match(item, find_calendar_match(item, components), url_helper)
    end

    it "should export to iCalendar" do
      location = stub_model(Location,
        :name => "A place",
        :address => "An address")
      events = [
        stub_model(Event,
          :id => 1,
          :name => "Meeting 1",
          :agenda => "Agenda 1",
          :starts_at => 1.day.from_now,
          :ends_at => 1.day.from_now + 1.hour),
        stub_model(Event,
          :id => 2,
          :name => "Meeting 2",
          :agenda => "Agenda 2",
          :starts_at => 2.days.from_now,
          :ends_at => 2.days.from_now + 1.hour),
      ]

      url_helper = lambda {|item| "http://foo.bar/#{item.id}"}
      data = Event.to_icalendar(events, :url_helper => url_helper)

      calendar = Vpim::Icalendar.decode(data).first
      components = calendar.to_a
      components.size.should == 2

      find_and_assert_calendar_match(events[0], components, url_helper)
      find_and_assert_calendar_match(events[1], components, url_helper)
    end
  end
end
