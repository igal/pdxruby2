class Event < ActiveRecord::Base
  belongs_to :member
  belongs_to :location
end
