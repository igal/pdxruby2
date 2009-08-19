class Event < ActiveRecord::Base
  belongs_to :member
  belongs_to :location

  # Has this event ended?
  def ended?
    return(self.ends_at < Time.now)
  end
end
