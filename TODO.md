###TODO
------------------
**Most Important**

- Handle rounds being started at a Round.start_time
  - Add a round_end_email_no_winner
- Test all of the new round stuff that was implemented.
  - Still need to add when starting rounds to use the roundhandler instead of manually doing shit.
- Fix The following error:
~~~
ActionView::Template::Error (undefined method `created_at' for nil:NilClass):
    25:         <td><%= link_to player.name, player_path(player) %></td>
    26:         <td><%= link_to target.name, player_path(target) %></td>
    27:         <td><% if not ass.active %>
    28:               <%= player.kills.last.created_at %>
    29:             <% end %>
    30:         </td>
    31:         <td><% if not ass.active %>
  app/views/administration/assignments.html.erb:28:in `block in _app_views_administration_assignments_html_erb___889393986295387079_50746440'
  app/views/administration/assignments.html.erb:14:in `_app_views_administration_assignments_html_erb___889393986295387079_50746440'
~~~
- Fix this error too:
~~~
Completed 500 Internal Server Error in 47.3ms

ActionView::Template::Error (undefined method `target_id' for nil:NilClass):
    4:   <div class="row">
    5:     <div class="col-sm-4">
    6:       <%= label_tag 'deceased_id', 'Deceased party', :class => "control-label" %>
    7:         <%= select_tag 'deceased_id', options_from_collection_for_select(@players, :id, :name, session[:player].assignments.where(:active => true).first.target_id), :class => "form-control" %>
    8:     </div>
    9:   </div><br>
    10:   <%= label_tag 'location', 'Kill Location', :class => "control-label" %>
  app/views/welcome/_report.html.erb:7:in `block in _app_views_welcome__report_html_erb__1024703549348737368_70003271350540'
  app/views/welcome/_report.html.erb:3:in `_app_views_welcome__report_html_erb__1024703549348737368_70003271350540'
  app/views/welcome/central.html.erb:15:in `_app_views_welcome_central_html_erb__1544718669312075228_36759080'
~~~
- Set the 'kill location' as a drop-down from a per-determined list of options (set options in config/application.yml)
- Re-do the central page so that everything is one page, no tabs. [wgd3]
  - Add a 'Current Assignment' page accessible by the player.
    - Should show the player their current assignment
    - This should alleviate any email issues that arise
  - Add a button or link to opt-in/opt-out of the next round (depending on player.auto_enroll)

**Less Important**
- Add a login page
  - Change all "you are not logged in" to this page
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
