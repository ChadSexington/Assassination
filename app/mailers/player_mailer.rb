class PlayerMailer < ActionMailer::Base
  default from: "no-reply@assassination-gssos.itos.redhat.com"

  # Confirm new registrations  
  def confirmation_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Confirm your membership to the OpenSource Assassination Organization.')
  end
  
  # Welcome a user after they confirm registration
  # This will send them the handbook
  def welcome_email(player)
    @player = player
    attachments['The_Assassins_Guide.odt'] = File.read("#{Rails.root}/public/The_Assassins_Guide.odt")
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Welcome to the OpenSource Assassination Organization!') 
  end

  # This will notify a single player of a new target that has been assigned to them.  
  def new_assignment_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    attachments.inline['target_photo'] = "Target's image (or possible the whole thingamabob)"
    mail(to: email_with_name, subject: 'New assignment from the OpenSource Assassination Organization')
  end

  # This will notify players that a round has started.
  def round_start_email(round)
    @round = round
    round.players.each do |player_id|
      @player = Player.find(player_id)
      email_with_name = "#{@player.name} <#{@player.email}>"
      mail(to: email_with_name, subject: 'New round and assignment from the OpenSouce Assassination Organization')
    end
  end

  # This will notify players that a round has started.
  def round_end_email(round)
    @round = round
    round.players.each do |player_id|
      @player = Player.find(player_id)
      email_with_name = "#{@player.name} <#{@player.email}>"
      mail(to: email_with_name, subject: "A winner for round #{round.id} has been determined! - OpenSouce Assassination Organization")
    end
  end

  # This will send a customized update to all players in the round
  def update_email(subject, message)
    @message = message
    current_round.players.each do |player_id|
      @player = Player.find(player_id)
      email_with_name = "#{@player.name} <#{@player.email}>"
      mail(to: email_with_name, subject: "Bulletin from the OpenSouce Assassination Organization")
    end
  end
  
  # This will notify players that a round has started.
  def ban_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'You have been banned from the OpenSouce Assassination Organization')
  end

  # This email will send out to all confirmed players
  def mass_email(subject, message)
    @message = message
    @players = Player.where(:confirmed => true)
    @players.each do |player|
      email_with_name = "#{player.name} <#{player.email}>"
      mail(to: email_with_name, subject: subject)
    end
  end

end
