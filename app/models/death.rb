class Death < ActiveRecord::Base
  attr_accessible :assassin_id, :location, :player_id, :recap, :recorded
  belongs_to :player
end
