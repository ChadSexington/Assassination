class Round < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :active, :id 
  has_many :assignments
  serialize :players

  after_create :generate_assignments
  
  def end(winner)
    if self.active == true
      self.players.each do |player|
        PlayerMailer.round_end_email(player, self, winner).deliver
      end
      self.update_attributes(:active => false)
      self.deactivate_assignments
    else
      Rails.logger.error "Tried to end active round"
      Rails.logger.error self.inspect
      return false
    end
  end

  def deactivate_assignments
    self.assignments.where(:active => true).each do |ass|
      ass.update_attributes(:active => false)
    end
  end

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
      assignment = self.assignments.where(:player_id => player_id).first
      PlayerMailer.round_start_email(player, self, assignment).deliver
    end
      
  end

end
