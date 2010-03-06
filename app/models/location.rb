# == Schema Information
# Schema version: 20091229031418
#
# Table name: locations
#
#  id         :integer         not null, primary key
#  name       :string(128)
#  homepage   :string(256)
#  address    :string(1024)
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  # Associations
  has_many :events

  # Scopes
  default_scope :order => 'lower(name) asc'

  # Validations
  validates_presence_of :name
  validates_presence_of :address
  validates_length_of :name, :maximum => 128
  validates_length_of :homepage, :maximum => 256, :if => :homepage
  validates_length_of :address, :maximum => 1024

  # Plugins
  has_paper_trail

  def can_alter?(user)
    return(user && user.admin?)
  end
end
