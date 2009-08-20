class Event < ActiveRecord::Base
  belongs_to :member
  belongs_to :location

  default_scope :order => 'ends_at desc'
  named_scope :recent, :order => 'ends_at desc', :limit => 5

  # Has this event ended?
  def ended?
    return(self.ends_at < Time.now)
  end
end
