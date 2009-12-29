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
  belongs_to :member
  belongs_to :location

  default_scope :order => 'ends_at desc', :include => [:location, :member]
  named_scope :recent, :order => 'ends_at desc', :limit => 5, :include => [:location, :member]

  validates_presence_of :name
  validates_presence_of :starts_at
  validates_presence_of :ends_at

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
          e.set_text  'LOCATION', "#{item.location.name}, #{item.location.address}"
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
end
