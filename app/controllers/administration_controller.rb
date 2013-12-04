class AdministrationController < ApplicationController

before_filter :authorize

  def index

  end

  def players
    @players = Player.all
  end
  
  def authorize
    if not admin?
      flash[:error] = "You are not an administrator"
      redirect_to '/welcome/index'
    end
  end

end
