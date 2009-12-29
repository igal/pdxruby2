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

  # Validations:
  validates_uniqueness_of :email
  validates_length_of :name, :minimum => 3
  validates_length_of :password, :minimum => 6
  validate :url_validator

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
