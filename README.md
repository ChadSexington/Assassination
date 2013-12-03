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

