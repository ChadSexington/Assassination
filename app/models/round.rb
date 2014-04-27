class Round < ActiveRecord::Base

  require 'emailhandler'
  require 'roundhandler'

  attr_accessible :end_time, :start_time, :active, :id, :started 
  has_many :assignments
  serialize :players

  after_create :generate_assignments
  after_create :add_handler

  def start_round
    self.update_attributes(:started => true) 
    self.players.each do |player_id|
      player = Player.find(player_id)
      assignment = self.assignments.where(:player_id => player_id).first
      safe_mail("round_start_email", [player, self, assignment])  
    end
  end

  def started?
    self.started
  end
 
  def stop_round
    ass = assignments.where(:active => true)
    case
    when ass.count > 1
      self.end("NOWINNER")
    when ass.count == 1
      self.end(Player.find(ass.first.player_id))
    end      
  end
 
  def end(winner)
    if self.active
      if winner.class != Player
        self.players.each do |player|
          safe_mail("round_end_email_no_winner", [player, self])
        end
        self.update_attributes(:active => false)
        self.deactivate_assignments
      else
        self.players.each do |player|
          safe_mail("round_end_email", [player, self, winner])
        end
        new_wins = winner.wins + 1
        winner.update_attributes(:wins => new_wins)
        self.update_attributes(:active => false)
        self.deactivate_assignments
      end
    else
      Rails.logger.error "Tried to end inactive round"
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
      players = self.players.shuffle
      players.each_with_index do |player,index|
        if index != (num_of_players - 1)
          new_target_id = players[index + 1].id
        else
          new_target_id = players[0].id
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
      safe_mail("round_activate_email", [player, self, assignment])  
    end
  end

  def safe_mail(method_name, args)
    EMAIL_HANDLER.enqueue({:method_name => method_name, :args => args})
  end

  def add_handler
    ROUND_HANDLER.enqueue({:action => "start", :time => self.start_time, :round_id => self.id})
    ROUND_HANDLER.enqueue({:action => "stop", :time => self.end_time, :round_id => self.id})
  end


end
