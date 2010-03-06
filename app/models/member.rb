# == Schema Information
# Schema version: 20091229031418
#
# Table name: members
#
#  id                   :integer         not null, primary key
#  name                 :string(128)
#  email                :string(512)
#  password             :string(256)
#  feed_url             :string(512)
#  irc_nick             :string(128)
#  persistence_token    :string(1024)
#  about                :string(16384)
#  created_at           :datetime
#  updated_at           :datetime
#  admin                :boolean
#  spammer              :boolean
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  website              :string(1024)
#

class Member < ActiveRecord::Base
  # Fields accessible via mass-assign:
  attr_accessible :name, :email, :feed_url, :irc_nick, :about, :spammer, :picture, :website

  # Named scopes:
  named_scope :sorted, :order => 'lower(name) asc'
  named_scope :spammers, :conditions => {:spammer => true}
  named_scope :nonspammers, :conditions => {:spammer => false}
  named_scope :latest, :order => 'created_at desc', :limit => 20

  # Validations:
  validate :url_validator
  validates_uniqueness_of :email
  validates_length_of :name, :in => 3..128
  validates_length_of :email, :in => 5..512
  validates_length_of :password, :in => 6...256
  validates_length_of :feed_url, :maximum => 512, :if => :feed_url
  validates_length_of :irc_nick, :maximum => 128, :if => :irc_nick
  validates_length_of :persistence_token, :maximum => 1024, :if => :persistence_token
  validates_length_of :about, :maximum => 16384, :if => :about
  validates_length_of :picture_file_name, :maximum => 255, :if => :picture_file_name
  validates_length_of :picture_content_type, :maximum => 255, :if => :picture_content_type
  validates_length_of :website, :maximum => 1024, :if => :website

  # Mixins
  include NormalizeUrlMixin

  # AuthLogic plugin
  acts_as_authentic do |c|
    c.email_field = :email
  end

  # PaperClip plugin
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>", :tiny => "32x32>" }

  #===[ Authentication and authorization ]================================

  def valid_password?(string)
    return self.class.hashed_password(string) == self.password
  end

  def self.hashed_password(string)
    return Digest::SHA1.hexdigest(string)
  end

  def password=(string)
    self.write_attribute(:password, self.class.hashed_password(string))
  end

  def can_alter?(user)
    return(user && (user.admin? || self == user))
  end

  #===[ Validations ]=====================================================

  # Ensure URLs are valid, else add validation errors.
  def url_validator
    return validate_url_attribute(:website, :feed_url)
  end
end
