class KillController < ApplicationController

  def create
    @kill = Kill.new(kill_params)
    @kill.player_id = current_player.id
    if @kill.save
      @death = Death.new(:assassin_id => current_player.id,
                         :player_id => kill_params[:deceased_id],
                         :recap => kill_params[:recap],
                         :location => kill_params[:location])
      @death.save
      flash[:success] = "Kill reported!"
      redirect_to '/central'
    else
      flash[:error] = "Kill could not be saved."
      redirect_to :back
    end
  end

  def show
    @kill = Kill.find(params[:id]) 
  end

private
  
  def kill_params
    params.permit(:deceased_id, :location, :recap)
  end

end
