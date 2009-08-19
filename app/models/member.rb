class Member < ActiveRecord::Base
  attr_accessible :name, :email, :feed_url, :irc_nick, :about

  default_scope :order => 'name asc'

  validates_uniqueness_of :email
  validates_length_of :name, :minimum => 1
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  acts_as_authentic do |c|
    c.login_field = :email
  end

  def valid_password?(string)
    return self.class.hashed_password(string) == self.password
  end

  def self.hashed_password(string)
    return Digest::SHA1.hexdigest(string)
  end

  def password=(string)
    write_attribute(:password, self.class.hashed_password(string))
  end
end
