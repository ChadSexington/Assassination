# Assassination #
###Configuration
-------------------
- config/application.yml
  - This contains the globabl configuration
    - admin_email: This should be the email used to register the first admin user. This must be set correctly or you will be unable to set any user as an administrator
    - project_name: This is used in several places throughout the views, including the brand in the navbar and many of the welcome pages.
    - data_dir: This should be set to the place you would like to keep images in your development environment. In Production, this will always be the $OPENSHIFT_DATA_DIR (see config/application.rb)
- config/ABOUT.md
  - This defines the content in /welcome/about. It is a markdown file, which is rendered in the browser. 
  - Convention is to use ### for section headers such as "rules" and "code of conduct".

###TODO
------------------
- Finish mailers
  - html templates need to be completed
  - New assignment emails will have to generate a 'card' type thing.
  - Ban email needs a form for an admin to type the message out.
- Add form for an administrator to verify/edit/delete kills/deaths (the hard part will be lining up the deaths w/ kills, since there is no association. Maybe there should be one?)
- Finish implementing user authentication.
  - Finish adding ability for user's to change their password
  - Fix edit player not showing form errors
  - Fix registration password fields disappearing if there is an error

**After the above is complete, the project should be usable, but likely buggy (alpha stage)**
- Add check box at player registration/edit to subscribe to news updates
  - Will also need to add a news mailer for this, as well as a hook when new news posts are created
- Make it so that if you screw up the player new/edit form, you don't have to re-upload the photo.
- Handle when a player not part of the curent round attempts to report a kill
- When a player is killed, send that player's assignment to the killer.
- Prettify everything
  - Most admin-facing pages (with the addition of central) were done very quickly, with a focus on functionality over asthetics. Need to go back through and get a real theme going.
- Finish the player profile page.
  - Pictures should be cropped to a standard size
  - Allow players to view other player's profiles
    - Need to add links in the kill-feed
  - Just keep it simple...
  - This should reflect what will be emailed in one of the mailers above
- Add error checking and validations to all forms
  - Player registration/edit form is completed
- Add error reporting for custom emails
- Make the handbook a pdf
  - Maybe make the handbook page read a text file (in markdown) which will be displayed and also offered as a downloadable pdf. Theres a gem for that somewhere...
- Devise a social model where players can 'message' each other and comment on kills
  - This is absolutely last priority

###List of mailers there should be:
- Confirm new registrations
- Welcome after confirmation
- Round start/new target
- New target
- Round stop
- Mass customized updates (admin form)
- Individual player email (admin form)
- Banhammer
