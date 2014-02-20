class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'emailhandler'

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
  
  def current_player
    session[:player]
  end

  def current_round
    Round.where(:active => true).last
  end
  
  def kd_ratio(player)
    kill_count = Kill.where(:player_id => player.id).count
    death_count = Death.where(:player_id => player.id).count
    "#{kill_count}/#{death_count}"
  end

  def safe_mail(method_name, args)
    @email_handler ||= EmailHandler.new
    @email_handler.enqueue({:method_name => method_name, :args => args})
  end

  helper_method :current_player
  helper_method :player_self? 
  helper_method :logged_in?
  helper_method :admin?
  helper_method :current_round
  helper_method :kd_ratio
  helper_method :safe_mail

end
