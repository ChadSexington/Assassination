class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin?
    session[:password] == CONFIG[:admin_password]
  end
  helper_method :admin?

end
