###TODO
------------------
- Add a 'Current Assignment' page accessible by the player.
  - Should show the player their current assignment
  - This should alleviate any email issues that arise
- Change user first + last name to uppercase BEFORE saving a nickname
- Keep track of number of times a player has won
  - Add a 'wins' field to wherever a player is displayed
- Finish implementing user authentication.
  - Finish adding ability for user's to change their password
  - Fix edit player not showing form errors

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
