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
