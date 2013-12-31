class PlayerMailer < ActionMailer::Base
  default from: "no-reply@assassination-gssos.itos.redhat.com"
  
  def confirmation_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Confirm your membership to the OpenSource Assassination Organization.')
  end
  
  def welcome_email(player)
    @player = player
    attachments['The_Assassins_Guide.odt'] = File.read("#{Rails.root}/public/The_Assassins_Guide.odt")
    email_with_name = "#{@player.name} <#{@player.email}>"
    mail(to: email_with_name, subject: 'Welcome to the OpenSource Assassination Organization!') 
  end
  
  def new_assignment_email(player)
    @player = player
    email_with_name = "#{@player.name} <#{@player.email}>"
    attachments.inline['target_photo'] = "Target's image (or possible the whole thingamabob)"
    mail(to: email_with_name, subject: 'New assignment from the OpenSource Assassination Organization')
  end
  
end
