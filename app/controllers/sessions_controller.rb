class SessionsController < ApplicationController

  def new
  end
  
  def create
    session[:password] = params[:password]
    if admin?
      flash[:success] = "Successfully logged in"
      redirect_to '/welcome/index'
    else
      reset_session
      flash[:error] = "Login Failed"
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    flash[:success] = "Logged out"
    redirect_to '/welcome/index'
  end

end
