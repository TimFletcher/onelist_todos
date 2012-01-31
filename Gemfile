source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'pg'
gem "aws-ses", "~> 0.4.3", :require => 'aws/ses'
# gem 'bcrypt-ruby', :require => 'bcrypt'

group :development do
  gem 'annotate', '2.4.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'exception_notification'
gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  # gem "guard-test"
  # gem "rb-fsevent"
  # gem 'spork'
  # gem 'spork-testunit', :git => "git://github.com/timcharper/spork-testunit.git"
  # gem 'growl_notify' # or gem 'growl'

  # Pretty printed test output
  gem 'turn', :require => false # Doesn't work with guard
end

