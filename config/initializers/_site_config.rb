# Global constants that apply to the site as a whole.
# Idea from http://www.smashingmagazine.com/2009/02/25/ruby-on-rails-tips/.

# NOTE: Initializers get loaded alphabetically. We named this file starting with an underscore, so that it gets loaded first, so other initializers can use the constants defined here.

# Name (identifier) of the project. Generally the same name as the directory containing the project.
PROJECT_NAME = Rails.root.to_s.split('/').last

# Override these - they will be used in the default layout.
SITE_NAME = 'Meezy.me'
SITE_TITLE = SITE_NAME + ('production' == Rails.env ? '' : " (#{Rails.env.upcase})")

# Hostname of the site. This will be used by Clearance to generate URLs in emails, to create a CSS signature, and possibly in several other places.
# NOTE: It's highly recommended that you hard-code this.
HOST = (ENV['SERVER_NAME']||'localhost').gsub(/[^A-Za-z0-9._-]/, '') # Ensure we get a valid hostname -- see http://shiflett.org/blog/2006/mar/server-name-versus-http-host.

# Create a CSS signature (http://archivist.incutio.com/viewlist/css-discuss/13291) for pages in your site.
CSS_SIGNATURE = HOST.gsub(/[.]/, '-')

# Years and name to list in copyright statements.
COPYRIGHT_YEARS = '2010'
COPYRIGHT_OWNER = 'Influence LLC'

# Version of jQuery to use.
JQUERY_VERSION = '1.4.2'

# Google Analytics code. Set this to enable Google Analytics on the site.
GOOGLE_ANALYTICS_CODE = nil

# Google Webmaster Tools (http://www.google.com/webmasters/) code. Set this to verify that you control the site, so you can see how Google views your site.
GOOGLE_WEBMASTERS_CODE = 'y6lDgmj4wzEKaPCs0KZBmz4N9feUSl8BODhPm13z7KI'

# Email exceptions to this list of addresses, if ExceptionNotifier is loaded.
EMAIL_EXCEPTIONS_TO = ['craig@boochtek.com']
if const_defined?('ExceptionNotification')
  ExceptionNotification::Notifier.exception_recipients = EMAIL_EXCEPTIONS_TO
end

# Reply address for emails. Used by Clearance, and possibly other gems/plugins.
DO_NOT_REPLY = "donotreply@#{HOST}"

# Email contact form feedback to this address.
EMAIL_FEEDBACK_TO = 'craig@boochtek.com'
