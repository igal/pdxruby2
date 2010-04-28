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

class Event < ActiveRecord::Base
  # Associations
  belongs_to :member
  belongs_to :location

  # Scopes
  default_scope :order => 'ends_at desc', :include => [:location, :member]
  named_scope :recent, :order => 'ends_at desc', :limit => 5, :include => [:location, :member]
  named_scope :future, :order => 'ends_at asc', :include => [:location, :member], :conditions => ['ends_at >= ?', Date.today.to_time.utc]

  # Validations
  validates_presence_of :name
  validates_presence_of :starts_at
  validates_presence_of :ends_at
  validates_length_of :name, :maximum => 128
  validates_length_of :status, :maximum => 64, :if => :status
  validates_length_of :agenda, :maximum => 16384, :if => :agenda
  validates_length_of :minutes, :maximum => 16384, :if => :minutes

  # Plugins
  has_paper_trail

  def can_alter?(user)
    return(user && (user.admin? || self.member == user))
  end

  # Return iCalendar data for the given events.
  #
  # Options:
  # * :title => String to use as the calendar title. Optional.
  # * :url_helper => Lambda that's called with an item that should return
  #   the URL for the item. Optional, defaults to not returning a URL.
  def self.to_icalendar(items, opts={})
    title = opts[:title] || "pdxruby events"
    url_helper = opts[:url_helper]

    calendar = Vpim::Icalendar.create2(Vpim::PRODID)
    calendar.title = title
    calendar.time_zone = Time.zone.tzinfo.name
    items.each do |item|
      calendar.add_event do |e|
        e.dtstart     item.starts_at
        e.dtend       item.ends_at
        e.summary     item.name
        e.created     item.created_at if item.created_at
        e.lastmod     item.updated_at if item.updated_at
        e.description item.agenda
        if item.location
          e.set_text  'LOCATION', [item.location.name, item.location.address].join(', ')
        end
        if url_helper
          url = url_helper.call(item)
          e.url       url
          e.uid       url
        end
      end
    end
    return calendar.encode.sub(/CALSCALE:Gregorian/, "CALSCALE:Gregorian\nMETHOD:PUBLISH")
  end

  # Has this event ended?
  def ended?
    return(self.ends_at < Time.now)
  end
  
  # Array of attributes that should be cloned by #to_clone.
  CLONE_ATTRIBUTES = [:location_id, :member_id, :name, :status, :agenda]

  # Return a new record with fields selectively copied from the original, and
  # the start_time and end_time adjusted so that their date is set to today and
  # their time-of-day is set to the original record's time-of-day.
  def self.clone_from(event)
    # Lookup record if needed
    source = event.kind_of?(Event) ? event : self.find(event)
    
    # Instantiate a new record
    target = self.new
    for attribute in CLONE_ATTRIBUTES
      target.send("#{attribute}=", source.send(attribute))
    end

    if source.starts_at
      target.starts_at = source.class._clone_time_for_today(source.starts_at)
    end
    if source.ends_at
      target.ends_at = source.class._clone_time_for_today(source.ends_at)
    end
    return target
  end
  
  # Return a time that's today but has the time-of-day component from the
  # +source+ time argument.
  def self._clone_time_for_today(source)
    today = Date.today.to_time
    return Time.local(today.year, today.mon, today.day, source.hour, source.min, source.sec, source.usec)
  end
end
