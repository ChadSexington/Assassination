class RoundsController < ApplicationController

  def new
    Round.all.each do |round|
      if round.active?
        flash[:error] = "There is already an active round with id: #{round.id}"
        redirect_to :back
      end
    end
    @players = Player.where(:confirmed => true)
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
    else
      flash[:error] = "There is currently no active round."
      redirect_to :back
    end
  end

  def start
    @round = Round.new(:active => true)
    @round.players = start_params[:player_ids]
    @round.start_time = Time.now
    if @round.save
      flash[:success] = "Round created"
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
