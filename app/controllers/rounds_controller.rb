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
      redirect_to :back
    end 
  end
  
  def end_current
    if @round = Round.where(:active => true).first
      @round.active = false
      @round.save
      flash[:success] = "Round #{@round.id} ended."
      @round.players.each do |player_id|
        player = Player.find(player_id)
        PlayerMailer.round_end_email(player, @round).deliver
      end
      redirect_to '/administration/index'
    else
      flash[:error] = "There is currently no active round."
      redirect_to '/administration/index'
    end
  end

  def start
    @round = Round.new(:active => true)
    @round.players = start_params[:player_ids]
    @round.start_time = Time.now
    if @round.save
      flash[:success] = "Round created"
      @round.players.each do |player|
        PlayerMailer.round_start_email(player, @round).deliver
      end
      redirect_to '/rounds/current'
    else
      flash[:error] = "Round could not be created."
    end
  end

private
  
  def start_params
    params.permit!
  end

end
