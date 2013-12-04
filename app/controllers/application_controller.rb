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
#    if session[:player]
#      session[:player].email == CONFIG[:admin_email]
#    else
#      false
#    end
  true
  end
  
  helper_method :logged_in?
  helper_method :admin?

end
