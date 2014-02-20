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
    Thread.new {
      attempts = 1
      logger.info "Sending email \"#{method_name}\" with arguments: \"#{args.to_s}\"."
      begin
        PlayerMailer.send(method_name, *args).deliver
      rescue Timeout::Error => e
        logger.error "Email timed out on attempt ##{attempts}."
        logger.error e.inspect
        if attempts < 5
          attempts += 1
          retry
        else
          FailedEmailHandler.add({:method_name => method_name, :args => args})
          logger.error "Giving up on sending email \"#{method_name}\" after #{attempts} attempts. Adding to queue to attempt at a later time."
        end
      rescue => e
        raise e
        logger.error "Email \"#{method_name}\" failed to send due to \"#{e.inspect}\""
      end
    }
  end

  helper_method :current_player
  helper_method :player_self? 
  helper_method :logged_in?
  helper_method :admin?
  helper_method :current_round
  helper_method :kd_ratio
  helper_method :safe_mail
end
