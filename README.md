# Assassination #
###Configuration
-------------------
- config/application.yml
  - This contains the globabl configuration
    - project_name: This is used in several places throughout the views, including the brand in the navbar and many of the welcome pages.
    - admin_password: This is temporary, will be removed when user authentication is implemented.
    - data_dir: This should be set to the place you would like to keep images in your development environment. In Production, this will always be the $OPENSHIFT_DATA_DIR (see config/application.rb)
- config/ABOUT.md
  - This defines the content in /welcome/about. It is a markdown file, which is rendered in the browser. 
  - Convention is to use ### for section headers such as "rules" and "code of conduct".

###TODO
------------------
- Add 'nickname' to player.
  - Should default to the players first name (Player.name.split.first)
  - Should only be able to be changed by an administrator
  - Kill-feed should use the nickname, however the report form should still use the full name for clarity.
- Add a player-ban form for admin
- Finish mailers
  - html templates need to be completed
    - Most messages will use a layout that I should defined as a partial
  - Hooks need to be added in some places (such as round start)
  - New assignment emails will have to generate a 'card' type thing.
- Add form for an administrator to verify/edit/delete kills/deaths (the hard part will be lining up the deaths w/ kills, since there is no association. Maybe there should be one?
- Add an admin form to add news posts
  - This will require creating a model + controller
- Make it so that if you screw up the player new/edit form, you don't have to re-upload the photo.
- Finish implementing user authentication.
  - Finish adding ability for user's to change their password
  - Fix edit player not showing form errors
  - Fix registration password fields disappearing if there is an error
  - Add a switch for a user to be an admin, instead of checking a configuration
    - This will allow for multiple admins, which is necessary.
- Make the handbook a pdf
  - Maybe make the handbook page read a text file (in markdown) which will be displayed and also offered as a downloadable pdf. Theres a gem for that somewhere...
- Finish the player profile page.
  - Pictures should be cropped to a standard size
  - Allow players to view other player's profiles
    - Need to add links in the kill-feed
  - Just keep it simple...
  - This should reflect what will be emailed in one of the mailers above
- Devise a social model where players can 'message' each other and comment on kills
  - This is absolutely last priority

###List of mailers there should be:
- Confirm new registrations
- Welcome after confirmation
- Round start/new target
- New target
- Round stop
- Mass customized updates (admin form)
- Individual player email (admin form))
- Banhammer
