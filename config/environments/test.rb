# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql
config.gem 'bullet', :version => '>= 1.7.6'

config.gem 'email_spec', :lib => 'email_spec', :version => '>= 0.6.2' # See http://github.com/bmabey/email-spec for docs.
config.gem 'rr', :lib => 'rr', :version => '>= 0.10.11'
config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :version => '>= 1.2.2'
config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com', :version => '>= 2.10.1'
config.gem 'webrat', :lib => false, :version => '>= 0.7.0'
config.gem 'database_cleaner', :lin => false
config.gem 'rspec', :lib => false, :version => '>= 1.3.0'
config.gem 'rspec-rails', :lib => false, :version => '>= 1.3.2' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
config.gem 'cucumber', :lib => false, :version => '>= 0.6.3'
config.gem 'cucumber-rails', :lib => false, :version => '>= 0.3.0'
config.gem 'chronic'
config.gem 'roodi'
config.gem 'reek'
config.gem 'flog'
config.gem 'flay'
config.gem 'jscruggs-metric_fu', :lib => 'metric_fu', :source => 'http://gems.github.com', :version => '1.0.2'
