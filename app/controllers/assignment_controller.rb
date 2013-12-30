class AssignmentController < ApplicationController
  
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
    
  end
  
  def edit
    
  end
  
  def index
   @assignments = Assignment.all 
  end
  
  def show
    @assignment = Assignment.find(params[:id]) 
  end
  
  def destroy
    
  end

private
  def assignment_params
    params.require(:assignment).permit!
  end
  
end
