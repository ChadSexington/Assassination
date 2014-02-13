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
- Add feature - when a kill is reported, assassin should receive new_assignment_email with the deceased's assignment.
  - This is going to take some back-end overhauling.
  - worknotes:
    - DONE First off, we need to change assignments to have an active:boolean attribute, instead of this integer bullshit.
    - DONE Assignments should use a target's id, not the target's name. wtf.
      - This will require changing a lot of existing code.
    - Players **will** have multiple assignments, and that is okay. However, they will only have on active assignment.
    - If the player is dead for the round, they should have no active assignments
  - This should all be done. Currently running into a really odd issue that I think is a problem with rails caching. Says im calling the method 'target' on an Assignment object in models/round.rb at line 33. I /used/ to do that there, but changed it to target_id to match the db.
- Finish mailers
  - html templates need to be completed
  - New assignment emails will have to generate a 'card' type thing.
  - Ban email needs a form for an admin to type the message out.
- Finish implementing user authentication.
  - Finish adding ability for user's to change their password
  - Fix edit player not showing form errors
  - Fix registration password fields disappearing if there is an error

**After the above is complete, the project should be usable, but likely buggy (alpha stage)**
- Add specific error messages to
  - Player logins
    - Player does not exist
    - Player exists, password incorrect
- Add check box at player registration/edit to subscribe to news updates
  - Will also need to add a news mailer for this, as well as a hook when new news posts are created
- Have round ends/starts automatically create small news posts with the summary of the round
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
