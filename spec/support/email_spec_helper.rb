# Warning -- we can't call this file 'email_spec', or else require 'email_spec' will try to load this file.
require 'email_spec'
Spec::Runner.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end
