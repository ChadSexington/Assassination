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
  def new_assignment_email(player, assignment)
    @player = player
    @assignment = assignment
    @target = Player.find(assignment.target_id)
    @target_kd_ratio = kd_ratio(@target)
    image_ext = @player.photo.url.split("?").first.split(".").last
    email_with_name = "#{@player.name} <#{@player.email}>"
    attachments.inline["target_photo#{image_ext}"] = File.read("#{CONFIG[:data_dir]}public/#{@player.photo.url.split("?").first}")
    attachments.inline['osas_banner'] = File.read("#{Rails.root}/app/assets/images/OSAS_card_banner.png")
    mail(to: email_with_name, subject: 'New assignment from the OpenSource Assassination Society')
  end

  # This will notify players that a round has started.
  def round_start_email(player, round, assignment)
    @round = round
    @player = player
    @assignment = assignment
    @target = Player.find(assignment.target_id)
    @target_kd_ratio = kd_ratio(@target)
    image_ext = @player.photo.url.split("?").first.split(".").last
    attachments.inline["target_photo#{image_ext}"] = File.read("#{CONFIG[:data_dir]}public/#{@player.photo.url.split("?").first}")
    attachments.inline['osas_banner'] = File.read("#{Rails.root}/app/assets/images/OSAS_card_banner.png")
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'New round and assignment from the OpenSouce Assassination Society')
  end

  # This will notify players that a round has started.
  def round_end_email(player, round, winner)
    @round = round
    @player = player
    @winner = winner
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: "A winner for round #{@round.id} has been determined! - OpenSouce Assassination Society")
  end

  # This will send a customized update to all players in the round
  def update_email(player, subject, body)
    @body = body
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: subject)
  end
  
  # This will notify a player of the banhammer that just smashed his face into the ground.
  def ban_email(player, reason)
    @player = player
    @reason = reason
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'You have been banned from the OpenSouce Assassination Society')
  end

  # This will notify a player that they have been un-banned and can join the game again.
  def unban_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Your ban from OpenSouce Assassination Society has been repealed.')
  end

  # This will send an email to an individual player
  # body is already rendered from markdown
  def individual_email(player, subject, body)
    @player = player
    @body = body
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: subject)
  end

private

  def kd_ratio(player)
    kill_count = Kill.where(:player_id => player.id).count
    death_count = Death.where(:player_id => player.id).count
    "#{kill_count}/#{death_count}"
  end

end
