# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.gem 'bullet', :version => '>= 1.7.6'
config.gem 'rails-footnotes', :version => '>= 3.6.6'

config.gem 'jscruggs-metric_fu', :lib => 'metric_fu', :source => 'http://gems.github.com', :version => '1.0.2'
config.gem 'chronic'
config.gem 'roodi'
config.gem 'reek'
config.gem 'flog'
config.gem 'flay'
config.gem 'email_spec', :lib => 'email_spec', :version => '>= 0.6.2' # See http://github.com/bmabey/email-spec for docs.
config.gem 'rr', :lib => 'rr', :version => '>= 0.10.11'
config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :version => '>= 1.2.2'
config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com', :version => '>= 2.10.1'
config.gem 'webrat', :lib => false, :version => '>= 0.7.0'
config.gem 'database_cleaner', :lin => false
config.gem 'cucumber-rails', :lib => false, :version => '>= 0.3.0'
config.gem 'cucumber', :lib => false, :version => '>= 0.6.3'
config.gem 'rspec-rails', :lib => false, :version => '>= 1.3.2'
config.gem 'rspec', :lib => false, :version => '>= 1.3.0'

ActiveRecord::Base.logger = Logger.new(STDOUT) if "irb" == $0
