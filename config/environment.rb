# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OneListRails::Application.initialize!

# ActionMailer::Base.smtp_settings = {
#   :user_name => "sendgridusername",
#   :password => "sendgridpassword",
#   :domain => "yourdomain.com",
#   :address => "smtp.sendgrid.net",
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true
# }