# Assassination #

###About
Assassination is a website frontend and controller for a game involving nerf guns.

The premise of the game is that numerous players are all given an assignment from a pool of those players. Each person must '*kill*' their assignment. When a player is killed, the assassin is given the deceased player's assignment. The last player standing wins the round.

###Installation
Assassination is built to be deployed on OpenShift.

You can deploy a version of OpenShift yourself with the following command:
~~~
rhc app-create APPNAME ruby-1.9 mysql-5.1 --from-code https://github.com/tiwillia/Assassination.git
~~~

You must then configure the application and push again to the deployment:
~~~
$ git add -A .
$ git commit -m "Configured application"
$ git push
~~~

Its that easy!


###Configuration
Most configuration is created and changed from within the website itself via the administration pages. There are a few configuration changes that will need to be made before deploying the application:

- config/application.yml
  - This contains the globabl configuration
    - admin_email: This should be the email used to register the first admin user. This must be set correctly or you will be unable to set any user as an administrator
    - project_name: This is used in several places throughout the views, including the brand in the navbar and many of the welcome pages.
    - data_dir: This should be set to the place you would like to keep images in your development environment. In Production, this will always be the $OPENSHIFT_DATA_DIR (see config/application.rb)
- config/ABOUT.md
  - This defines the content in /welcome/about. It is a markdown file, which is rendered in the browser. 
  - Convention is to use ### for section headers such as "rules" and "code of conduct".

*note*: commit count is excessive due to deploying and testing with openshift
