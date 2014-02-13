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
      pass_on_assignment(kill_params[:assassin_id], kill_params[:deceased_id])
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
  
  def pass_on_assignment(assassin_id, deceased_id)
    assassin_assignment = Assignment.where(:player_id => assassin_id, :active => true).last
    deceased_assignment = Assignment.where(:player_id => deceased_id, :active => true).last
    assassin_assignmnet.update_attributes(:active => false)
    deceased_assignment.update_attributes(:active => false)
    
    deceased_old_target_id = deceased_assignment.target_id
    new_assignment = Assignment.new(:player_id => assassin_id,
                                    :target_id => deceased_old_target_id,
                                    :active => true,
                                    :round_id => current_round.id)
    new_assignment.save
    Player_mailer.new_assignment_email(Player.find(new_assignment.player_id), new_assignment).deliver
    
  end

end
