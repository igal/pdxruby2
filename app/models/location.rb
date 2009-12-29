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
  has_many :events

  default_scope :order => 'lower(name) asc'

  validates_presence_of :name
  validates_presence_of :address

  has_paper_trail

  def can_alter?(user)
    return(user && user.admin?)
  end
end
