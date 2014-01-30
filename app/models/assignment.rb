class Assignment < ActiveRecord::Base

  belongs_to :player
  belongs_to :round

  validates_uniqueness_of :target
end
