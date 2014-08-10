###TODO
------------------
**Most Important**

- Add Kill -9 shiz 
  Summary:
    To keep rounds moving faster than the 14 day time limit and to allow players that have been killed something to do while waiting, the kill -9 Initiative will be invoked after 7 days from start of the round. All dead players will be given a list of active players and will be allowed to target them, still following normal game and round rules.  They will not be able to claim victory of the round or add to their current stats however. If killed again from a defending active player they are out for the remaining round. 
  Expectations:
  - [DONE] There should be an option to enable/disable when starting a round
  - [DONE] The option should specify at what time before the kill -9 begins
  - [DONE] Kills/deaths for dead players will not be logged.
    - Ran into a problem here. Kills are reported by the number of kill entries in the database for a specific player. If a kill9 kill will be reported, we will have to have an attribute on the kill that says whether it counts or not. Then, fix this wherever we report kills.
  - [DONE] Dead players will receive a list of all live players
  - [MAYBE] Dead players killing the second-to-last live player should end the round, with the winner being the last live player.
  - [DONE] Dead players can be killed again, then are complety out of the game.
    - Again, this should not affect points.
  - [DONE] When kill9 is enabled and a player is killed, that player should be added to the kill9 players.
  Database additions:
  - Round
    - boolean kill9 default => false
    - datetime kill9_start_time
    - kill9_players text (ARRAY)
  - Kill
    - boolean recorded default => true
  - Death
    - boolean recorded default => true

  - JUST TEST~!!!!

- Players cannot access other player's pages
  - Should enable players to access other player's pages by only allowing parts of the player page to be seen by the player or an admin.
  - Should also like to players in kill feed.
- Players should have a single place to look at all other player's stats.
 - This could just be a 'statistics' database table that is updated at the end of a round, where all the stats for all players are listed. This seems logical since stats will not be updated outside of a round and players shouldn't be able to see updates to stats during a round, or they can cheat.
- Add ability for player in double kill that didn't report the kill to edit the recap given.
 - That, or change the way double kills are displayed on the kill feed (easier 4 sure)
- Re-do the central page so that everything is one page, no tabs. [wgd3]
  - Add a 'Current Assignment' page accessible by the player.
    - Should show the player their current assignment
    - This should alleviate any email issues that arise
  - Add a button or link to opt-in/opt-out of the next round (depending on player.auto_enroll)

**Less Important**
- Add javascript jazz in cookie for central/kill-feed
- Differentiate between 'defensive' kills and 'offensive' kills. Basically, if the kill was the target, its offensive, if the kill was not the target, its defensive. A simply entry in the kill database table should suffice, with a small hook in the kill_controller.
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

RFE's:
-=~~~~~~~~~~~~~~~~~~~~~~~~~~=-
- Add social network-type features
- Daily update email + page
  - Would require asking the user to subscribe or unsubscribe from this feed.
- Re-do the central page
- Add achievments and awards
