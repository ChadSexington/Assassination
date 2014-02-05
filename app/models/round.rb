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
      PlayerMailer.new_assignment_email(@player).deliver
    end
      
  end

end
