class Kill < ActiveRecord::Base
  attr_accessible :deceased_id, :location, :player_id, :recap, :no_display, :recorded
  belongs_to :player
end
