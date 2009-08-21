# Cacher is a cache observer, which expires the cache when something changes.
class Cacher < ActiveRecord::Observer
  observe :member, :location, :event

  def self.expire(*args)
    # Delete everything. NOTE: This only works with the "file_store" cache.
    Rails.cache.delete_matched(//)
  end

  def after_save(*args)
    self.class.expire(*args)
  end

  def after_destroy(*args)
    self.class.expire(*args)
  end
end
