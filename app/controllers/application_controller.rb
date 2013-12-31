class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    if session[:player]
      return true
    else
      return nil
    end
  end

  def admin?
    if session[:player]
      session[:player].admin
    else
      false
    end
  end
 
  def player_self?(player)
    player.username == session[:player].username
  end

  helper_method :player_self? 
  helper_method :logged_in?
  helper_method :admin?

end
