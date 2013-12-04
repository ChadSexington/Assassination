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
- Finish implementing user authentication.
  - Add ability for user's to edit their own profile
  - Add ability for user's to change their password
  - Add confirmation mailer (see below)
  - Following most of http://www.aidanf.net/2006/05/28/rails-authentication-tutorial.html
  - Note that the above is old. May need to be adapted 
- Add multiple mailers
  - One to initiate/confirm new players
  - One to send out new targets
  - One to mass-mail event notices (starts and stops)
  - Maybe more idk
- Add 'events' controller that will handle all 'kills'
  - There should be a route to /events/feed that lists, in order, all kills
  - /events/index should contain a tree of sorts?
  - /events/new will be a form for users to submit a kill
- Devise a method for kills to be recoreded in events controller via visiting a link in a QR code
- Create a view for the actual card that will be printed out.
  - This should reflect what will be emailed in one of the mailers above
