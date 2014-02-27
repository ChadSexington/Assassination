###TODO
------------------
**Most Important**

- News post show in the reverse order by date. This needs to be fixed.
- Add a way to view old assignments. The assignment view should show assignments from the previous round instead of nothing if there is no round.
- Add a parse_date helper method that outputs the date from DateTime in a pretty string
- Re-do the central page so that everything is one page, no tabs. [wgd3]
  - Add a 'Current Assignment' page accessible by the player.
    - Should show the player their current assignment
    - This should alleviate any email issues that arise
  - Add a button or link to opt-in/opt-out of the next round (depending on player.auto_enroll)

**Less Important**
- Set the 'kill location' as a drop-down from a per-determined list of options (set options in config/application.yml)
- Add a login page
  - Change all "you are not logged in" redirects to this page
- Create a 'Polls' page where people can suggest changes to the game and vote on them
- Finish implementing user authentication.
  - Finish adding ability for user's to change their password
  - Fix edit player not showing form errors
- Add specific error messages to
  - Player logins
    - Player does not exist
    - Player exists, password incorrect
- Add check box at player registration/edit to subscribe to news updates
  - Will also need to add a news mailer for this, as well as a hook when new news posts are created
- Have round ends/starts automatically create small news posts with the summary of the round
- Make it so that if you screw up the player new/edit form, you don't have to re-upload the photo.
- Finish the player profile page.
  - Allow players to view other player's profiles
    - Need to add links in the kill-feed
  - This should reflect what will be emailed in one of the mailers above
- Add error checking and validations to all forms
  - Player registration/edit form is completed
- Make the handbook a pdf
  - Maybe make the handbook page read a text file (in markdown) which will be displayed and also offered as a downloadable pdf. Theres a gem for that somewhere...
- Devise a social model where players can 'message' each other and comment on kills
  - This is absolutely last priority
