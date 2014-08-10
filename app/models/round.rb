class Round < ActiveRecord::Base

  require 'emailhandler'
  require 'roundhandler'

  attr_accessible :end_time, :start_time, :active, :id, :started, :kill9_players, :kill9, :players, :live_player_ids
  attr_accessible :winner_id

  has_many :assignments

  serialize :players, Array
  serialize :kill9_players
  serialize :live_player_ids

  before_create :initialize_arrays
  after_create :generate_assignments
  after_create :add_handler

  def initialize_arrays
    self.kill9_players = []
    self.live_player_ids = []
  end

  def start_round
    self.update_attributes(:started => true)
    player_ids = self.players.map {|p| p.id}
    self.update_attributes(:live_player_ids => player_ids) 
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
        self.update_attributes(:active => false, :winner_id => winner.id)
        self.deactivate_assignments
      end
    else
      Rails.logger.error "Tried to end inactive round"
      Rails.logger.error self.inspect
      return false
    end
  end

  # Set all assignments associated with round to inactive
  # Returns nothing
  def deactivate_assignments
    self.assignments.where(:active => true).each do |ass|
      ass.update_attributes(:active => false)
    end
  end

  # Activate kill9 on a round
  # Returns nothing
  def activate_kill9
    if self.kill9
      self.update_attributes!(:kill9_players => dead_players)
      # Define variable so we don't loop through the same code with same output repeatedly
      players_alive = live_players
      self.players.each do |player|
        safe_mail("kill9_start_email", [player, self, players_alive])
      end
    else
      return nil
    end
  end

  # Remove a player from kill9 list
  def remove_kill9_player(player)
    list = self.kill9_players
    if not list.delete(player).nil?
      self.update_attributes(:kill9_players => list)
    end
  end

  # Add a player to the kill9 list
  def add_kill9_player(player)
    list = self.kill9_players
    list << player
    self.update_attributes(:kill9_players => list)
  end
 
  # List all dead players in the round 
  # Returns array of Player objects
  def dead_players
    self.players - live_players
  end
  
  # List all live players in the round 
  # Returns array of Player objects
  def live_players
    live_players = Array.new
    self.live_player_ids.each do |p_id|
       live_players << Player.find(p_id)
    end
    live_players
  end

  def player_killed(player_id)
    new_a = self.live_player_ids - [player_id.to_i]
    if self.update_attributes(:live_player_ids => new_a)
      return true
    end
    nil
  end

  def can_end?
    return false if not self.active
    return false if not self.started
    Rails.logger.info "FINDME: Checking end of round:"
    Rails.logger.info "live players: #{live_players}"
    if self.live_player_ids.count == 1
      winner = Player.find(self.live_player_ids.first)
      return true, winner
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
    if self.kill9
      ROUND_HANDLER.enqueue({:action => "activate_kill9", :time => self.kill9_start_time, :round_id => self.id})
    end
    ROUND_HANDLER.enqueue({:action => "stop", :time => self.end_time, :round_id => self.id})
  end


end
