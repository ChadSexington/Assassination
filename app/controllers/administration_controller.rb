class AdministrationController < ApplicationController

before_filter :authorize

  def index
    flash[:error] = flash[:error]
    flash[:success] = flash[:success]
    redirect_to '/welcome/central'
  end

  def players
    @players = Player.all
  end

  def submit_ban
    @player = Player.find(params[:id])
    if @player.banned == true
      flash[:error] = "Player is already banned"
      redirect_to '/administration/index'
    end
  end
  
  def unban_player 
    @player = Player.find(params[:id])
    @player.banned = false
    if @player.save
      flash[:success] = @player.name + " has been un-banned."
      safe_mail("unban_email", @player)
      redirect_to "/administration/players"
    else
      flash[:error] = @player.name + " could not be un-banned."
      redirect_to "/administration/players"
    end
  end

  def ban_player
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :strikethrough => true, :fenced_code_blocks => true, :underline => true, :quote => true, :footnotes => true)
    reason = markdown.render(ban_params[:reason])
    @player = Player.find(params[:id])
    @player.banned = true
    if @player.save
      flash[:success] = @player.name + " has been banned."
      safe_mail("ban_email", [@player, reason])
      redirect_to "/administration/players"
    else
      flash[:error] = @player.name + " could not be banned."
      redirect_to "/administration/players"
    end
  end

  def assignments
    @players = Player.all
    if current_round.nil?
      @assignments = Assignment.where(round_id: Round.all.last.id)
    else 
      @assignments = Assignment.where(round_id: current_round.id)
    end
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
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :strikethrough => true, :fenced_code_blocks => true, :underline => true, :quote => true, :footnotes => true)
    subject = email_params[:subject]
    body = markdown.render(email_params[:body])
    recipients = email_params[:recipients]
    case email_params[:email_type]
    when "mass_update"
      if recipients == "all"
          Player.where(:confirmed => true, :banned => false).each do |player|
            safe_mail("update_email", [player, subject, body])
          end
      elsif recipients == "round"
          current_round.players.each do |player|
            safe_mail("update_email", [player, subject, body])
          end
      else
        flash[:error] = "Hidden field missing from form. Contact somebody who has the power."
        redirect_to :back
      end
    when "individual_email"
      player_id = email_params[:recipients]
      player = Player.find(player_id)
      safe_mail("individual_email", [player, subject, body])
    end
    flash[:success] = "Emails queued."
    redirect_to '/administration/index'
  end

private

  def email_params
    params.permit(:email_type, :body, :subject, :recipients)
  end
  
  def ban_params
    params.permit(:id, :reason)
  end
end
