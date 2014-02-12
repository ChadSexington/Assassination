class Round < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :active, :id 
  has_many :assignments
  serialize :players

  after_create :generate_assignments

private
  
  def generate_assignments
    if self.players.empty?
      return nil
    end
    finished = false
    assignment_hash = Hash.new
    while finished == false
      target_ids = self.players.shuffle
      self.players.each do |player_id|
        new_target_id = target_ids.pop
        if new_target_id == player_id
          break
        end
        assignment_hash[player_id] = new_target
      end
      if assignment_hash.count = self.players
        finished = true
      end
    end
    assignment_hash.each do |player_id, target_id|
      self.assignments.create(player_id: player_id,
                              target: target_id,
                              status: 0,)   
    end
    self.players.each do |player_id|
      player = Player.find(player_id)
      PlayerMailer.round_start_email(player, self).deliver
    end
      
  end

end
