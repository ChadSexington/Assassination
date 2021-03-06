class PlayerMailer < ActionMailer::Base

  default from: "gss-assassination-game@redhat.com"

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
    @image_ext = @player.photo.url.split("?").first.split(".").last
    email_with_name = "#{@player.name} <#{@player.email}>"
    attachments.inline["target_photo.#{@image_ext}"] = File.read("#{CONFIG[:data_dir]}public/#{@target.photo.url.split("?").first}")
    attachments.inline['osas_banner.png'] = File.read("#{Rails.root}/app/assets/images/OSAS_card_banner.png")
    mail(to: email_with_name, subject: 'New assignment from the OpenSource Assassination Society')
  end

  # This will notify player that a round has started
  def round_start_email(player, round, assignment)
    @round = round
    @player = player
    @assignment = assignment
    @target = Player.find(assignment.target_id)
    @target_kd_ratio = kd_ratio(@target)
    @image_ext = @player.photo.url.split("?").first.split(".").last
    attachments.inline["target_photo.#{@image_ext}"] = File.read("#{CONFIG[:data_dir]}public/#{@target.photo.url.split("?").first}")
    attachments.inline['osas_banner.png'] = File.read("#{Rails.root}/app/assets/images/OSAS_card_banner.png")
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'A new round has begun! | OpenSouce Assassination Society')
  end

  # This will notify players that a round has been activated.
  # This is different from started because the round is not actually running until the start_time has passed.
  def round_activate_email(player, round, assignment)
    @round = round
    @player = player
    @assignment = assignment
    @target = Player.find(assignment.target_id)
    @target_kd_ratio = kd_ratio(@target)
    @image_ext = @player.photo.url.split("?").first.split(".").last
    @start_time = @round.start_time.strftime("%m/%d/%Y %H:%M") 
    attachments.inline["target_photo.#{@image_ext}"] = File.read("#{CONFIG[:data_dir]}public/#{@target.photo.url.split("?").first}")
    attachments.inline['osas_banner.png'] = File.read("#{Rails.root}/app/assets/images/OSAS_card_banner.png")
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'New round and assignment from the OpenSouce Assassination Society')
  end

  # This will notify players that a round has ended.
  def round_end_email(player, round, winner)
    @round = round
    @player = player
    @winner = winner
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: "A winner for round #{@round.id} has been determined! - OpenSouce Assassination Society")
  end

  # This will notify players that a round has ended, without a winner.
  def round_end_email_no_winner(player, round)
    @round = round
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: "Round #{@round.id} has ended! - OpenSouce Assassination Society")
  end

  def kill9_start_email(player, round, live_players)
    @round = round
    @player = player
    @live_players = live_players
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: "Kill -9 rule now in affect for Round #{@round.id} - OpenSouce Assassination Society")
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
    kill_count, death_count = player.kd_ratio
    "#{kill_count}/#{death_count}"
  end

end
