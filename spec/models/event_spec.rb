# == Schema Information
# Schema version: 20091229031418
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
      component.location.should == [item.location.name, item.location.address].join(', ') if item.location
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
          :ends_at => 1.day.from_now + 1.hour,
          :location => location),
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

  describe "when cloning" do
    describe "cloning from an event" do
      it "should return a cloned event" do
        time_of_day = 6.hours + 5.minutes + 4.seconds
        source_time = Time.parse('2009/8/7') + time_of_day
        source_duration = 2.hours
        attributes = {
          :location_id => 1,
          :member_id => 2,
          :name => "IMPORTANT EVENT!",
          :status => "omgkittens",
          :agenda => "The same thing we do every night",
          :starts_at => source_time,
          :ends_at => source_time + source_duration,
          :minutes => "Yay!",
          :created_at => Time.now - 1.day
        }
        source = stub_model(Event, attributes)
        
        result = Event.clone_from(source)
        result.starts_at.should == Date.today.to_time + time_of_day
        result.ends_at.should == Date.today.to_time + time_of_day + source_duration
        result.name.should == source.name
        result.member_id.should == source.member_id
        result.location_id.should == source.location_id
        result.agenda.should == source.agenda
        result.minutes.should be_blank
      end
    end

    describe "cloning a time" do
      it "should return date for today, but time-of-day from given event" do
        time_of_day = 6.hours + 5.minutes + 4.seconds
        source = Time.parse('2009/8/7') + time_of_day

        result = Event._clone_time_for_today(source)
        result.should == Date.today.to_time + time_of_day
      end
    end
  end

  describe "can_alter?" do
    before do
      @admin  = stub_model(Member, :admin => true)
      @owner  = stub_model(Member)
      @member = stub_model(Member)
      @event  = stub_model(Event, :member => @owner)
    end

    it "should be for admin" do
      @event.can_alter?(@admin).should be_true
    end

    it "should be for owner" do
      @event.can_alter?(@owner).should be_true
    end

    it "should not be for non-owner non-admin" do
      @event.can_alter?(@member).should be_false
    end

    it "should not be for anonymous" do
      @event.can_alter?(nil).should be_false
    end
  end
end
