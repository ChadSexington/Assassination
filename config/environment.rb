# Load the rails application
require File.expand_path('../application', __FILE__)

# Load additional Libraries
require 'emailhandler'
require 'roundhandler'

# Initialize the rails application
RailsApp::Application.initialize!

EMAIL_HANDLER = EmailHandler.new
ROUND_HANDLER = RoundHandler.new
