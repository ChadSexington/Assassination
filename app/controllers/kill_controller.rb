class KillController < ApplicationController

  def create

    # Check for kill9 stuff
    if current_round.kill9 && !current_round.kill9_players.empty?
      if current_round.kill9_players.include?(current_player)
        record_kill = false
      else
        record_kill = true
      end
    
      deceased_is_kill9_player = false
      current_round.kill9_players.each do |p| 
        if p.id == kill_params[:deceased_id]
          deceased_is_kill9_player = true
          break
        end
      end
      
      if deceased_is_kill9_player
        record_death = false
      else
        record_death = true
      end
    else
      record_kill = true
      record_death = true
    end

    # Create the kill
    @kill = Kill.new(:player_id => current_player.id, 
                          :deceased_id => kill_params[:deceased_id], 
                          :location => kill_params[:location], 
                          :recap => kill_params[:recap],
                          :recorded => record_kill)
    if !Assignment.where(:target_id => @kill.deceased_id, :active => true).empty? || !current_round.kill9_players.empty?
      if @kill.save
        current_round.player_killed(kill_params[:deceased_id])
        @death = Death.new(:assassin_id => current_player.id,
                           :player_id => kill_params[:deceased_id],
                           :recap => kill_params[:recap],
                           :location => kill_params[:location],
                           :recorded => record_death)
        @death.save

        assassin_assignment = Player.find(current_player.id).assignments.where(:active => true).last

        if kill_params[:double_kill]
          # Create kill and death for deceased and player
          other_kill = Kill.new(:player_id => kill_params[:deceased_id], 
                                :deceased_id => current_player.id, 
                                :location => kill_params[:location], 
                                :recap => kill_params[:recap])
          other_kill.save
          current_round.player_killed(current_player.id)
          other_death = Death.new(:assassin_id => kill_params[:deceased_id],
                                  :player_id => current_player.id,
                                  :recap => kill_params[:recap],
                                  :location => kill_params[:location])
          other_death.save

          pass_on_double_kill_assignment(current_player.id, kill_params[:deceased_id])
        else
          if assassin_assignment.nil?
            # If the assassin has no assignment, just kill the player and move on.
            # This is the case when a dead kill9 player kills a live player also.
            if !current_round.kill9_players.empty?
              current_round.add_kill9_player(Player.find(kill_params[:deceased_id])) 
            end
            pass_on_extra_assignment(current_player.id, kill_params[:deceased_id]) 
          else
            if assassin_assignment.target_id == kill_params[:deceased_id]
              pass_on_normal_assignment(current_player.id, kill_params[:deceased_id])
            else
              if current_round.kill9_players.include?(Player.find(kill_params[:deceased_id]))
                # If kill9 is active and a live player killed a kill9 player
                current_round.remove_kill9_player(Player.find(kill_params[:deceased_id]))
              else
                pass_on_extra_assignment(current_player.id, kill_params[:deceased_id])
              end
            end
          end
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
    params.permit(:deceased_id, :location, :recap, :double_kill)
  end

  # When two players kill each other as the same time
  # This will check to see if they had each other as assignments
  # If they did, it will end the round unless there are other active assignments
  # Otherwise, player with assassin as target will get decased's old target
  def pass_on_double_kill_assignment(assassin_id, deceased_id)
    assassin_id = assassin_id.to_i
    deceased_id = deceased_id.to_i
    assassin_assignment = Player.find(assassin_id).assignments.where(:active => true).last
    deceased_assignment = Player.find(deceased_id).assignments.where(:active => true).last
    assassin_assignment.update_attributes(:active => false) if assassin_assignment
    deceased_assignment.update_attributes(:active => false) if deceased_assignment
    deceased_old_target_id = deceased_assignment.target_id if deceased_assignment
    assassin_old_target_id = assassin_assignment.target_id if assassin_assignment

    if assassin_old_target_id == deceased_id && deceased_old_target_id != assassin_id
      # give player with assassin as target the decaseds old target
      assignment_with_assassin_as_target = Assignment.where(:target_id => assassin_id, :active => true).last
      assignment_with_assassin_as_target.update_attributes(:active => false)
      new_assignment = Assignment.new(:player_id => assignment_with_assassin_as_target.player_id,
                                    :target_id => deceased_old_target_id,
                                    :active => true,
                                    :round_id => current_round.id)
      new_assignment.save
    elsif deceased_old_target_id == assassin_id && assassin_old_target_id != deceased_id
      # give player with decased as target the assisgin's old target
      assignment_with_deceased_as_target = Assignment.where(:target_id => deceased_id, :active => true).first
      assignment_with_deceased_as_target.update_attributes(:active => false)
      new_assignment = Assignment.new(:player_id => assignment_with_deceased_as_target.player_id,
                                    :target_id => assassin_old_target_id,
                                    :active => true,
                                    :round_id => current_round.id)
      new_assignment.save
    elsif assassin_old_target_id == deceased_id && deceased_old_target_id == assassin_id && Assignment.where(:active => true).empty?
      can_end, winner = current_round.can_end?
      if can_end
        current_round.end(false)
      end
    elsif assassin_old_target_id == deceased_id && deceased_old_target_id == assassin_id
      Rails.logger.info "Double kill happened with both players having each other as assignment, two other assignments still exist"
      # Do nothing, other assignments should be fine.
    end 
  end

  # This will pass on an assignment when the killer finished his assigned target
  def pass_on_normal_assignment(assassin_id, deceased_id)
    assassin_assignment = Player.find(assassin_id).assignments.where(:active => true).last
    deceased_assignment = Player.find(deceased_id).assignments.where(:active => true).last
    assassin_assignment.update_attributes(:active => false) if assassin_assignment
    deceased_assignment.update_attributes(:active => false) if deceased_assignment
    deceased_old_target_id = deceased_assignment.target_id if deceased_assignment

    can_end, winner = current_round.can_end?
    if can_end
      current_round.end(Player.find(assassin_id))
    else 

      new_assignment = Assignment.new(:player_id => assassin_id,
                                    :target_id => deceased_old_target_id,
                                    :active => true,
                                    :round_id => current_round.id)
      new_assignment.save
      safe_mail("new_assignment_email", [Player.find(new_assignment.player_id), new_assignment])
    end
  end

  # This will pass on an assignment when the killer kills someone other than their assignment.
  def pass_on_extra_assignment(assassin_id, deceased_id)
    deceased_assignment = Player.find(deceased_id).assignments.where(:active => true).last
    affected_assignment = Assignment.where(:active => true, :target_id => deceased_id).last
    deceased_assignment.update_attributes(:active => false) if deceased_assignment
    affected_assignment.update_attributes(:active => false) if affected_assignment

    can_end, winner = current_round.can_end?
    if can_end
      current_round.end(winner)
    else
      new_assignment = Assignment.new(:player_id => affected_assignment.player_id,
                                      :target_id => deceased_assignment.target_id,
                                      :active => true,
                                      :round_id => current_round.id)
      new_assignment.save
      safe_mail("new_assignment_email", [Player.find(new_assignment.player_id), new_assignment])
    end
  end

end
