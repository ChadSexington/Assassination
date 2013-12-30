class Assignment < ActiveRecord::Base
  
  validates_presence_of :target
  validates_uniqueness_of :id
  
  belongs_to :assassin
end