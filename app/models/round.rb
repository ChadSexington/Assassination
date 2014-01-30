class Round < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :active, :id 
  has_many :assignments
  serialize :players

  before_save :parse_players

  def end
  
  end

  def start

  end

private
  
  def parse_players
    players = []
    self.assignments.each do |a|
      players << a.player_id
    end
    self.players = players
  end

end
