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
    targets = self.players.shuffle
    self.players.each do |player_id|
      tar = targets.pop
      if tar == nil
        tar = self.players.sample
        while tar == player_id do
          tar = self.players.sample
        end
      elsif tar == player_id
        new_tar = targets.pop
        targets.push(tar)
        tar = new_tar
      end
      self.assignments.create(player_id: player_id,
                            target: tar,
                            status: 0,)   
    end
    self.players.each do |player_id|
      player = Player.find(player_id)
      PlayerMailer.round_start_email(player, self).deliver
    end
      
  end

end
