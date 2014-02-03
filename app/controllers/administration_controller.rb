class AdministrationController < ApplicationController

before_filter :authorize

  def index

  end

  def players
    @players = Player.all
  end

  def assignments
    @players = Player.all
    @assignments = Assignment.all 
  end
  
  def authorize
    if not admin?
      flash[:error] = "You are not an administrator"
      redirect_to '/welcome/index'
    end
  end
  
  def emails
  end

  def send_mail
    subject = email_params[:subject]
    body = email_params[:body]
    recipients = email_params[:recipients]
    case email_params[:email_type]
    when "mass_update"
      if recipients == "all"
        PlayerMailer.mass_email(subject, body)
      elsif recipients == "round"
        PlayerMailer.update_email(subject, body)
      else
        flash[:error] = "Hidden field missing from form. Contact somebody who has the power."
        redirect_to :back
      end
    when "individual_email"
      player_id = email_params[:recpients]
      PlayerMailer.individual_email(player_id, subject, body)
    end
    flash[:success] = "Emails queued."
    redirect_to '/administration/index'
  end

private

  def email_params
    params.permit(:email_type, :body, :subject, :recipients)
  end

end
