class RoundsController < ApplicationController

  def new
    Round.all.each do |round|
      if round.active?
        flash[:error] = "There is already an active round with id: #{round.id}"
        redirect_to :back
      end
    end
    @players = Player.where(:confirmed => true, :banned => false)
    @round = Round.new
  end

  def current
    @round = Round.where(:active => true).first
    if @round.nil?
      flash[:error] = "There is currently no active round."
      redirect_to '/administration/index'
    end 
  end
 
  def end_round
    if @round = Round.where(:active => true).first
      @round = current_round
      @players = Array.new
      current_round.players.each do |player_id|
        @players << Player.find(player_id)
      end
    else
      flash[:error] = "There is currently no active round."
      redirect_to '/administration/index'
    end
  end
 
  def end_current
    @round = current_round
    if current_round.end(Player.find(end_params[:winner]))
      flash[:success] = "Round #{@round.id} ended."
    else
      flash[:error] = "Could not end Round #{@round.id}."
    end
    redirect_to '/administration/index'
  end

  def start
    @round = Round.new(:active => true)
    @round.players = Array.new
    start_params[:player_ids].each do |player_id|
      player = Player.find(player_id)
      @round.players.push(player)
    end
    @round.start_time = Time.now
    if @round.save
      flash[:success] = "Round created"
      redirect_to '/rounds/current'
    else
      flash[:error] = "Round could not be created."
    end
  rescue Timeout::Error => e
    @error = e
    flash[:error] = "Request took too long, try again"
    redirect_to '/rounds/new'
  end

private
  
  def start_params
    params.permit!
  end
  
  def end_params
    params.permit(:winner)
  end

end
