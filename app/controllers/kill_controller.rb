class KillController < ApplicationController

  def create
    @kill = Kill.new(kill_params)
    @kill.player_id = current_player.id
    if not Assignment.where(:target_id => @kill.deceased_id, :active => true).empty?
      if @kill.save
        @death = Death.new(:assassin_id => current_player.id,
                           :player_id => kill_params[:deceased_id],
                           :recap => kill_params[:recap],
                           :location => kill_params[:location])
        @death.save

        assassin_assignment = Player.find(current_player.id).assignments.where(:active => true).last
        if assassin_assignment.target_id == kill_params[:deceased_id]
          pass_on_normal_assignment(current_player.id, kill_params[:deceased_id])
        else
          pass_on_extra_assignment(current_player.id, kill_params[:deceased_id])
        end
        flash[:success] = "Kill reported!"
        redirect_to '/central'
      else
        flash[:error] = "Kill could not be saved."
        redirect_to :back
      end
    else
      flash[:error] = "Deceased player is already dead or not playing this round"
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

  # This will pass on an assignment when the killer finished his assigned target
  def pass_on_normal_assignment(assassin_id, deceased_id)
    assassin_assignment = Player.find(assassin_id).assignments.where(:active => true).last
    deceased_assignment = Player.find(deceased_id).assignments.where(:active => true).last
    assassin_assignment.update_attributes(:active => false)
    deceased_assignment.update_attributes(:active => false)
    deceased_old_target_id = deceased_assignment.target_id

    if deceased_old_target_id != assassin_id
      new_assignment = Assignment.new(:player_id => assassin_id,
                                    :target_id => deceased_old_target_id,
                                    :active => true,
                                    :round_id => current_round.id)
      new_assignment.save
      safe_mail("new_assignment_email", [Player.find(new_assignment.player_id), new_assignment])
    else
      current_round.end(Player.find(assassin_id))
    end
  end

  # This will pass on an assignment when the killer kills someone other than their assignment.
  def pass_on_extra_assignment(assassin_id, deceased_id)
    deceased_assignment = Player.find(deceased_id).assignments.where(:active => true).last
    affected_assignment = Assignment.where(:active => true, :target_id => deceased_id).last
    deceased_assignment.update_attributes(:active => false)
    affected_assignment.update_attributes(:active => false)
    
    if deceased_assignment.target_id != affected_assignment.player_id
      new_assignment = Assignment.new(:player_id => affected_assignment.player_id,
                                      :target_id => deceased_assignment.target_id,
                                      :active => true,
                                      :round_id => current_round.id)
      new_assignment.save
      safe_mail("new_assignment_email", [Player.find(new_assignment.player_id), new_assignment])
    else
      # This may need additional tuning. Tests need to be run.
      current_round.end(Player.find(assassin_id))
    end
  end

end
