class AssignmentsController < ApplicationController
  
  def new
    if admin?
      @assignment = Assignment.new
    else
      flash[:error] = "Must be an administrator to create new assignments."
      redirect_to :back
    end
  end
  
  def create
    if admin?
      @assignment = Assignment.new(assignment_params)
      if @assignment.save
        flash[:success] = "Assignment with id " + @assignment.id + " successfully created."
        redirect_to @assignment
      else
        flash[:error] = "Assignment could not be created."
        redirect_to new
      end
    else
      flash[:error] = "Must be an administrator to create new assignments."
      redirect_to :back
    end 
  end
  
  def update
    @assignment = Assignment.find(assignment_params[:id])
    if player_self?(Player.find(@assignment.player_id)) || admin?
      if @assignment.update_attributes(assignment_params)
        flash[:success] = "Assignment with id " + @assignment.id + " successfully updated."
        redirect_to @assignment
      else
        flash[:error] = "Assignment could not be updated"
        redirect_to @assignment
      end
    else
      flash[:error] = "Must be an administrator to create new assignments."
      redirect_to :back
    end
 
  end
  
  def edit 
    @assignment = Assignment.find(params[:id])
    if not player_self?(Player.find(@assignment.player_id)) || admin?
      flash[:error] = "You are not authorized to edit this assignment."
      redirect_to :back
    end
  end
  
  def index
   @assignments = Assignment.all 
  end
  
  def show
    if player_self? || admin?
      @assignment = Assignment.find(params[:id]) 
    else
      flash[:error] = "You are not authorized to view this assignment."
      redirect_to :back
    end
  end
  
  def destroy
    
  end

  # This should display a page where all players are listed
  # Each should have a checkbox beside their name
  # The ones that are picked will be given an assignment
  def start_round
    if admin?
      @players = Player.all
    else
      flash[:error] = "You are not authorized to view this page"
      redirect_to '/welcome/index'
    end
  end

  def generate
    
  end

private
  def assignment_params
    params.require(:assignment).permit!
  end
  
end
