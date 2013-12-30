class Assignment < ActiveRecord::Base

  belongs_to :player

  validates_uniqueness_of :target
end
