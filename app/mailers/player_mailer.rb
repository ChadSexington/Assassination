class PlayerMailer < ActionMailer::Base
  default from: "no-reply@assassination-gssos.itos.redhat.com"

  # Confirm new registrations  
  def confirmation_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Confirm your membership to the OpenSource Assassination Society.')
  end
  
  # Welcome a user after they confirm registration
  # This will send them the handbook
  def welcome_email(player)
    @player = player
    attachments['The_Assassins_Guide.odt'] = File.read("#{Rails.root}/public/The_Assassins_Guide.odt")
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Welcome to the OpenSource Assassination Society!') 
  end

  # This will notify a single player of a new target that has been assigned to them.  
  def new_assignment_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    attachments.inline['target_photo'] = "Target's image (or possible the whole thingamabob)"
    mail(to: email_with_name, subject: 'New assignment from the OpenSource Assassination Society')
  end

  # This will notify players that a round has started.
  def round_start_email(player, round)
    @round = round
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'New round and assignment from the OpenSouce Assassination Society')
  end

  # This will notify players that a round has started.
  def round_end_email(player, round)
    @round = round
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: "A winner for round #{round.id} has been determined! - OpenSouce Assassination Society")
  end

  # This will send a customized update to all players in the round
  def update_email(player, subject, body)
    @body = body
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: subject)
  end
  
  # This will notify a player of the banhammer that just smashed his face into the ground.
  def ban_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'You have been banned from the OpenSouce Assassination Society')
  end

  # This will send an email to an individual player
  # body is already rendered from markdown
  def individual_email(player, subject, body)
    @player = player
    @body = body
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: subject)
  end

end
