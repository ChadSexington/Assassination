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
    num_of_players = self.players.count
    assignment_hash = Hash.new
    while finished == false
      targets = self.players.shuffle
      self.players.each do |player|
        new_target_id = targets.pop.id
        if new_target_id == player.id
          break
        end
        assignment_hash[player.id] = new_target_id
      end
      if assignment_hash.count == num_of_players
        finished = true
      else
        assignment_hash.clear
      end
    end
    assignment_hash.each do |player_id, target_id|
      self.assignments.create(:player_id => player_id,
                              :target_id => target_id,
                              :active => true)   
    end
    self.players.each do |player_id|
      player = Player.find(player_id)
      PlayerMailer.round_start_email(player, self).deliver
    end
      
  end

end
